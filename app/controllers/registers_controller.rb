class RegistersController < ApplicationController
  before_action :set_register_and_check_permission, only: [:show, :edit, :update, :destroy]

  def index
    authorize :register
    @registers = current_organization.registers
  end

  def show
  end

  def new
    @register = current_organization.registers.new
    authorize @register
  end

  def create
    @register = current_organization.registers.new(register_params)
    authorize @register
    if @register.save
      redirect_to registers_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def register_params
    params.require(:register).permit(:name, :active)
  end

  def set_register_and_check_permission
  end
end
