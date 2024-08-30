class DisposalDescriptionsController < ApplicationController
  before_action :set_disposal_description_and_check_permission, only: %i[show edit update destroy]

  def index
    authorize :disposal_description
    @disposal_descriptions = DisposalDescription.all
  end

  def show
  end

  def new
    @disposal_description = DisposalDescription.new
    authorize @disposal_description
  end

  def create
    @disposal_description = DisposalDescription.new(disposal_description_params)
    @disposal_description.organization_id = current_organization.id
    @disposal_description.user_id = current_user.id
    authorize @disposal_description
    @disposal_description.save
    redirect_to [:edit, @disposal_description]
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def disposal_description_params
    params[:disposal_description].permit(:name)
  end

  def set_disposal_description_and_check_permission
    @disposal_description = DisposalDescription.find(params[:id])
    authorize @disposal_description
  end
end
