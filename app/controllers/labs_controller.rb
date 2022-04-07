class LabsController < ApplicationController
  before_action :set_lab_and_check_permission, only: [:show, :edit, :update, :delete]

  def index
    authorize :lab
    @labs = current_organization.labs
  end

  def show
    @disposals = @lab.disposals
  end

  def new
    @lab = current_organization.labs.new
    authorize @lab
  end

  def create
    @lab = current_organization.labs.new(name: params[:lab][:name])
    authorize @lab
    if @lab.save
      redirect_to labs_path, notice: "Laboratorio creato correttamente."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @lab.update(name: params[:lab][:name])
      redirect_to labs_path, notice: "Il nome del laboratorio è stato modificato."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_lab_and_check_permission
    @lab = current_organization.labs.find(params[:id])
    authorize @lab
  end
end
