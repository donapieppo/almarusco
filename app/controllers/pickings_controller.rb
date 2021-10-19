class PickingsController < ApplicationController
  before_action :set_picking_and_check_permission, only: [:show, :edit, :update, :delete]

  def index
    authorize :picking
    @pickings = current_organization.pickings
  end

  def new
    @picking = current_organization.pickings.new
    authorize @picking
  end

  def create
    @supplier = Supplier.find(params[:supplier_id])
    @picking = current_organization.pickings.new(supplier_id: @supplier.id)
    authorize @picking
    if @picking.save
      @picking.fill_with_defoult_disposals
      redirect_to edit_picking_path(@picking), notice: 'Ritiro creato.'
    else
      redirect_to root_path, alert: 'ERRORE'
    end
  end

  def edit
    @possible_disposals = @picking.possible_disposals.order(:id).includes(:user, :producer, disposal_type: [:un_code, :cer_code])
  end

  def update
    @picking.update(picking_params)
    redirect_to [:edit, @picking]
  end

  def destroy
  end

  private

  def set_picking_and_check_permission
    @picking = current_organization.pickings.find(params[:id])
    authorize @picking
  end

  def picking_params
    params[:picking].permit(:date, disposal_ids: [])
  end
end
