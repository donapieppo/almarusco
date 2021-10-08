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
      render action: :new
    end
  end

  private

  def set_lab_and_check_permission
    @lab = Lab.find(params[:id])
    authorize @lab
  end
end


