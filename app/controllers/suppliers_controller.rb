class SuppliersController < ApplicationController
  before_action :set_supplier_and_check_permission, only: [:edit, :update]

  def index
    authorize Supplier
    @suppliers = Supplier.order(:name).all
  end

  def new
    @supplier = Supplier.new
    authorize @supplier
  end

  def create
    @supplier = Supplier.new(supplier_params)
    authorize @supplier
    if @supplier.save
      redirect_to suppliers_path, notice: "Il fornitore è stato creato."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to suppliers_path, notice: "Il fornitore è stato aggiornato."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  private

  def supplier_params
    params[:supplier].permit(:name, :pi, :address)
  end

  def set_supplier_and_check_permission
    @supplier = Supplier.find(params[:id])
    authorize @supplier
  end
end
