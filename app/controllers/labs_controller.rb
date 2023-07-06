class LabsController < ApplicationController
  before_action :set_lab_and_check_permission, only: [:show, :edit, :update, :delete]

  def index
    authorize :lab
    @labs = Hash.new { |h, k| h[k] = [] }
    current_organization.labs.includes(:building).order("buildings.name, labs.name").each do |lab|
      @labs[lab.building] << lab
    end
    @used_labs_ids = current_organization.disposals.group(:lab_id).count
  end

  def show
    @disposals = @lab.disposals
  end

  def new
    @lab = current_organization.labs.new
    @buildings = current_organization.buildings.to_a
    authorize @lab
  end

  def create
    @lab = current_organization.labs.new(lab_params)
    authorize @lab
    if @lab.save
      redirect_to labs_path, notice: "Laboratorio creato correttamente."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
    @buildings = current_organization.buildings.to_a
  end

  def update
    if @lab.update(lab_params)
      redirect_to labs_path, notice: "Il nome del laboratorio è stato modificato."
    else
      @buildings = current_organization.buildings.to_a
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def lab_params
    params[:lab].permit(:name, :building_id)
  end

  def set_lab_and_check_permission
    @lab = current_organization.labs.find(params[:id])
    authorize @lab
  end
end
