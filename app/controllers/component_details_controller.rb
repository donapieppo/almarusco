class ComponentDetailsController < ApplicationController
  before_action :set_component_detail_and_check_permission, only: %i[edit update destroy]

  def new
    @disposal_description = DisposalDescription.find(params[:disposal_description_id])
    @component_detail = @disposal_description.component_details.new
    authorize @component_detail
  end

  def create
    @disposal_description = DisposalDescription.find(params[:disposal_description_id])
    @component_detail = @disposal_description.component_details.new(component_detail_params)
    authorize @component_detail
    if @component_detail.save
      redirect_to [:edit, @disposal_description]
    end
  end

  def edit
    @disposal_description = @component_detail.disposal_description
  end

  def update
    if @component_detail.update(component_detail_params)
      redirect_to [:edit, @component_detail.disposal_description]
    end
  end

  def destroy
  end

  private

  def component_detail_params
    params[:component_detail].permit(:name, :percentage, :un_code_id, hp_code_ids: [], adr_ids: [], hazard_ids: [])
  end

  def set_component_detail_and_check_permission
    @component_detail = ComponentDetail.find(params[:id])
    authorize @component_detail
  end
end
