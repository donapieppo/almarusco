class DisposalsController < ApplicationController
  helper DisposalHelper

  before_action :set_disposal_type, only: %i(new create)
  before_action :set_permitted_producers, only: %i(new clone create)
  before_action :set_disposal_and_check_permission, only: %i(show edit update destroy approve unapprove)

  def index
    authorize :disposal
    @highlight_id = params[:h].to_i
    @disposals = current_organization.disposals.undelivered.includes(:user, :producer, :lab, disposal_type: [:cer_code, :un_code, :hp_codes, :adrs])
    if policy(current_organization).manage?
      if params[:u]
        @user = User.find(params[:u].to_i)
        @disposals = @disposals.user_or_producer(@user.id)
      end
    else
      @disposals = @disposals.user_or_producer(current_user.id)
    end
    @disposals = @disposals.order("disposals.id DESC, disposals.user_id ASC")
    @disposals_cers = current_organization.disposal_types
                                          .includes(:cer_code)
                                          .where(id: @disposals.map(&:disposal_type_id)).map(&:cer_code).uniq
  end

  def show
  end

  def choose_disposal_type
    @disposal_types = current_organization.disposal_types.with_all_includes.order('cer_codes.name')
    authorize :disposal
  end

  def new
    @disposal = current_user.disposals.new(disposal_type_id: @disposal_type.id, 
                                           organization_id: current_organization.id)
    authorize @disposal
  end

  def clone
    @orig = Disposal.find(params[:id])
    @disposal_type = @orig.disposal_type
    @disposal = current_user.disposals.new(disposal_type_id: @disposal_type.id,
                                           organization_id: current_organization.id,
                                           lab_id: @orig.lab_id,
                                           producer_id: @orig.producer_id)
    authorize @disposal
    render action: :new
  end

  def create
    # if @producers => only operator and @producers array that must contain producer_id
    # else is producer itsself
    if params[:disposal][:producer_id] && @producers 
      @producer = User.find(params[:disposal][:producer_id])
      unless @producer && @producers.include?(@producer)
        raise "PRODUCER ERRATO" 
      end
    else
      @producer = current_user
    end

    @disposal = current_user.disposals.new(disposal_params)
    @disposal.organization_id = current_organization.id
    @disposal.disposal_type_id = @disposal_type.id
    @disposal.producer_id = @producer.id

    authorize @disposal
    if @disposal.save
      redirect_to disposals_path(h: @disposal.id, anchor: @disposal.id), notice: "Salvata la richiesta di scarico con identificativo #{@disposal.id}. Consigliamo di scrivere il numero identificativo sul collo."
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @disposal.update(disposal_params)
      redirect_to @disposal
      # redirect_to disposals_path(h: @disposal.id, anchor: @disposal.id)
    else
      render action: :edit
    end
  end

  def approve
    respond_to do |format|
      res = @disposal.approve!
      format.html { redirect_to @disposal }
      format.js
    end
  end

  def unapprove
    respond_to do |format|
      res = @disposal.unapprove!
      format.html { redirect_to @disposal }
      format.js
    end
  end

  def destroy
    @disposal.destroy
    redirect_to disposals_path
  end

  def search
    authorize :disposal
    requested_disposal_id = params[:search_string].to_i
    @disposal = current_organization.disposals.find_by_id(requested_disposal_id)

    if @disposal
      @disposal = current_organization.disposals.find_by_id(requested_disposal_id)
      redirect_to @disposal
    else
      redirect_to root_path, alert: "Non esiste l'identificativo del rifiuto in questa UL."
    end
  end

  def archive
    authorize :disposal
    @year = 2021
    @disposals = current_organization.disposals
                                     .delivered
                                     .where('YEAR(disposals.delivered_at) = ?', @year)
                                     .includes(:user, :producer, :lab, disposal_type: [:cer_code, :un_code, :hp_codes, :adrs])
    @disposal_types = current_organization.disposal_types.where(id: @disposals.map(&:disposal_type_id).sort.uniq)
  end

  private

  def disposal_params
    params[:disposal].permit(:volume, :kgs, :lab_id, :notes)
  end

  def set_disposal_type
    @disposal_type = current_organization.disposal_types.find(params[:disposal_type_id])
  end

  def set_disposal_and_check_permission
    @disposal = current_organization.disposals.find(params[:id])
    authorize @disposal
  end

  # if user is operator can also be producer for themself
  def set_permitted_producers
    @producers = current_user.permitted_producers(current_organization)
    if @producers.any? && current_user.authorization.can_dispose?(current_organization)
      @producers << current_user 
    end
  end
end
