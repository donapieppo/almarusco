class LabsController < ApplicationController
  def index
    authorize :lab
    @labs = current_organization.labs
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
end


