class DisposalsController < ApplicationController
  helper DisposalHelper

  before_action :set_disposal_type, only: %i(new create)
  before_action :set_disposal_and_check_permission, only: %i(show edit update destroy approve unapprove)

  def index
    if policy(current_organization).manage?
      @disposals = current_organization.disposals
      if params[:u]
        @user = User.find(params[:u].to_i)
        @disposals = @disposals.where(user_id: @user.id)
      end
    else
      @disposals = current_user.disposals.where(organization: current_organization)
    end
    @disposals = @disposals.order(:user_id, :created_at)
    authorize :disposal
  end

  def show
  end

  def choose_disposal_type
    @disposal_types = current_organization.disposal_types
    authorize :disposal
  end

  def new
    @disposal = current_user.disposals.new(disposal_type_id: @disposal_type.id, 
                                           organization_id: current_organization.id)
    authorize @disposal
  end

  def create
    @disposal = current_user.disposals.new(disposal_params)
    @disposal.organization_id = current_organization.id
    @disposal.disposal_type_id = @disposal_type.id
    authorize @disposal
    if @disposal.save
      redirect_to disposals_path, notice: "Salvata la richiesta di scarico con identificativo #{@disposal.id}. Consigliamo di scrivere il numero identificativo sul collo."
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @disposal.update(disposal_params)
      redirect_to disposals_path
    else
      render action: :edit
    end
  end

  def approve
    @disposal.approve!
    redirect_to @disposal
  end

  def unapprove
    @disposal.unapprove!
    redirect_to @disposal
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
      redirect_to root_path, alert: "Manca l'identificativo dell rifiuto."
    end
  end

  private

  def disposal_params
    params[:disposal].permit(:volume, :kgs)
  end

  def set_disposal_type
    @disposal_type = current_organization.disposal_types.find(params[:disposal_type_id])
  end

  def set_disposal_and_check_permission
    @disposal = current_organization.disposals.find(params[:id])
    authorize @disposal
  end
end
