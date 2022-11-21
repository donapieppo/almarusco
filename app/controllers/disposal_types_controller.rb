class DisposalTypesController < ApplicationController
  before_action :set_disposal_type_and_check_permission, only: %i(edit update destroy)

  def index
    @disposal_types = current_organization.disposal_types.includes(:cer_code, :un_code, :hp_codes, :adrs, :pictograms).order('cer_codes.name, un_codes.name')
    authorize :disposal_type
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

  private

  def disposal_type_params
    params[:disposal_type].permit(:cer_code_id, :un_code_id, :physical_state, :adr, :separable, :notes, hp_code_ids: [], adr_ids: [], pictogram_ids: [])
  end

  def set_disposal_type_and_check_permission
    @disposal_type = DisposalType.find(params[:id])
    # check organization
    authorize @disposal_type
  end
end

