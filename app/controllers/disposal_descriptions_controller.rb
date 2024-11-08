class DisposalDescriptionsController < ApplicationController
  before_action :set_disposal_description_and_check_permission, only: %i[show edit update destroy]

  def index
    authorize :disposal_description
    @disposal_descriptions = DisposalDescription.includes(:organization, :user).order("organizations.name, users.upn").all
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
    if @disposal_description.update(disposal_description_params)
      redirect_to [:edit, @disposal_description]
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def disposal_description_params
    params[:disposal_description].permit(:name, :department, :place, :chief, :lab, pictogram_ids: [])
  end

  def set_disposal_description_and_check_permission
    @disposal_description = DisposalDescription.find(params[:id])
    authorize @disposal_description
  end
end
