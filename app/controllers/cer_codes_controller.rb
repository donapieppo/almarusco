class CerCodesController < ApplicationController
  before_action :set_cer_code_and_check_permission, only: [:show, :edit, :update, :delete]

  def index
    authorize :cer_code
    @cer_codes = CerCode.order(:name).all
  end

  def new
    @cer_code = CerCode.new
    authorize @cer_code
  end

  def create
    @cer_code = CerCode.new(cer_code_params)
    authorize @cer_code
    if @cer_code.save
      redirect_to cer_codes_path, notice: "Laboratorio creato correttamente."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @cer_code.update(cer_code_params)
      redirect_to cer_codes_path, notice: "Il nome del laboratorio è stato modificato."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_cer_code_and_check_permission
    @cer_code = CerCode.find(params[:id])
    authorize @cer_code
  end

  def cer_code_params
    params[:cer_code].permit(:name, :description, :danger)
  end
end
