class BuildingsController < ApplicationController
  before_action :set_building_and_check_permission, only: [:show, :edit, :update]

  def index
    authorize :building
    @buildings = current_organization.buildings.order(:name)
  end

  def show
  end

  def new
    @organization = Organization.find(params[:organization_id])
    @building = @organization.buildings.new
    authorize @building
  end

  def create
    @organization = Organization.find(params[:building][:organization_id])
    @building = @organization.buildings.new(building_params)
    authorize @building
    if @building.save
      redirect_to organizations_path, notice: "Edificio creato correttamente."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @building.update(building_params)
      redirect_to organizations_path, notice: "L'edificio è stato modificato."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  private

  def set_building_and_check_permission
    @building = Building.find(params[:id])
    authorize @building
  end

  def building_params
    params[:building].permit(:name, :description)
  end
end
