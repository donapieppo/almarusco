class RegisterPolicy < ApplicationPolicy
  before_action :set_register_and_check_permission, only: [:show, :edit, :update, :destroy]

  def index
    @registers = current_organization.registers
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def register_params
    params.require(:register).allow(:name, :active)
  end

  def set_register_and_check_permission
  end
end
