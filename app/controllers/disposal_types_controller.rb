class DisposalTypesController < ApplicationController
  before_action :set_disposal_type_and_check_permission, only: [:show, :edit, :update, :destroy]

  def index
    @disposal_types = current_organization.disposal_types.includes(:cer_code, :un_code, :hp_codes, :adrs, :pictograms).order("cer_codes.name, un_codes.name")
    authorize :disposal_type
  end

  def show
    @year = Date.today.year
  end

  def new
    @disposal_type = current_organization.disposal_types.new
    authorize @disposal_type
  end

  def create
    @disposal_type = current_organization.disposal_types.new(disposal_type_params)
    authorize @disposal_type
    if @disposal_type.save
      redirect_to disposal_types_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @disposal_type.update(disposal_type_params)
      redirect_to disposal_types_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @disposal_type.organization == current_organization
      @disposal_type.destroy
    end
    redirect_to disposal_types_path
  end

  private

  def disposal_type_params
    params[:disposal_type].permit(
      :cer_code_id, :un_code_id, :physical_state, :separable, :hidden, :notes, :legalizable,
      hp_code_ids: [], adr_ids: [], pictogram_ids: [], container_ids: []
    )
  end

  def set_disposal_type_and_check_permission
    @disposal_type = DisposalType.find(params[:id])
    # check organization
    authorize @disposal_type
  end
end
