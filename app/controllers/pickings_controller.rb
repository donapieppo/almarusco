require 'csv'
class PickingsController < ApplicationController
  before_action :set_picking_and_check_permission, only: [:show, :edit, :update, :delete, :new_print_request, :print_request, :deliver, :complete]

  def index
    authorize :picking
    @pickings = current_organization.pickings.includes(:supplier, :picking_documents).order("date desc")
  end

  def show
    @disposals_hash = Hash.new { |hash, key| hash[key] = [] }

    @picking.disposals.include_all.each do |d|
      @disposals_hash[d.disposal_type] << d
    end
  end

  # more a choose_supplier than a new :-)
  def new
    @current_pickings = current_organization.pickings.undelivered.all # da fissare con all prima di aggiungere new
    @suppliers = Supplier.where.not(id: @current_pickings.pluck(:supplier_id))
    @picking = current_organization.pickings.new
    authorize @picking
  end

  def create
    @supplier = Supplier.find(params[:supplier_id])
    @picking = current_organization.pickings.new(supplier_id: @supplier.id)
    authorize @picking
    if @picking.save
      @picking.fill_with_default_disposals
      redirect_to edit_picking_path(@picking), notice: "Il ritiro è stato correttamente creato."
    else
      redirect_to root_path, alert: "ERRORE"
    end
  end

  def edit
    @can_change_disposals = !@picking.delivered?
    if @can_change_disposals
      @possible_disposals = @picking.possible_disposals.order(:id).includes(:user, :producer, disposal_type: [:un_code, :cer_code])
    end
    @previous_contacts = current_organization.pickings.where("contact > ''").select(:contact).group(:contact).distinct.map(&:contact).sort
    @previous_address = current_organization.pickings.where("address > ''").select(:address).group(:address).distinct.map(&:address).sort
  end

  def update
    @picking.update(picking_params)
    redirect_to @picking
  end

  def destroy
  end

  def new_print_request
    authorize :picking
    @request = PickingRequest.new(@picking)
  end

  def print_request
    filename = "stampa_ritiro_#{@picking.supplier.name}_#{@picking.date}"
    pdf = PickingPrint.new(@picking, params.to_unsafe_hash)
    send_data pdf.render, filename: "#{filename}.pdf", type: "application/pdf", disposition: "inline"
  end

  def deliver
    if @picking.deliver!
      redirect_to pickings_path, notice: "Il ritiro è stato consegnato."
    else
      redirect_to [:edit, @picking], alert: @picking.errors[:base]
    end
  end

  def complete
    @picking.complete!
    redirect_to pickings_path, notice: "I rifiuti associati sono archiviati."
  end

  private

  def set_picking_and_check_permission
    @picking = if current_user.nuter?
      Picking.find(params[:id])
    else
      current_organization.pickings.find(params[:id])
    end
    authorize @picking
  end

  def picking_params
    params[:picking].permit(:date, :address, :contact, disposal_ids: [])
  end

  def data_array(volumes_and_kgs, array_headers: false)
    res = []
    if array_headers
      res << ["CER", "Stato fisico", "Descrizione rifiuto", "Tipo di imbal.ggio", "N° e tipo di colli", "Peso (Kg)", "Caratteristiche di pericolo", "ADR", "N. ONU", "Classe ADR"]
    end
    volumes_and_kgs.each do |disposal_type, vols_and_kgs|
      volumes = vols_and_kgs[:volumes].keys.map(&:to_i).sort
      line = []
      line << disposal_type.cer_code.to_s
      line << disposal_type.physical_state_to_s
      line << disposal_type.cer_code.description
      line << volumes.map { |v| (v == 200) ? "Fusto" : "Tanica" }.sort.uniq.join(" e ")
      line << volumes.map { |v| "da #{v} litri: #{vols_and_kgs[:volumes][v.to_s]}" }.join("")
      line << vols_and_kgs[:kgs]
      line << disposal_type.hp_codes_to_s
      line << (disposal_type.adr ? "si" : "")
      line << disposal_type.un_code.to_s
      line << disposal_type.adrs_to_s
      res << line
    end
    res
  end

  def data_arry_from_form
  end
end
