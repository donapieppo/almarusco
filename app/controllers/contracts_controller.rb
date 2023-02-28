class ContractsController < ApplicationController
  before_action :get_contract_and_supplier_and_check_permission, only: [:edit, :update, :destroy]

  def new
    @supplier = Supplier.find(params[:supplier_id])
    @cer_code = CerCode.find(params[:cer_code_id])
    @contract = @supplier.contracts.new(cer_code: @cer_code)
    authorize @contract
  end

  def create
    @supplier = Supplier.find(params[:supplier_id])
    @cer_code = CerCode.find(params[:contract][:cer_code_id])
    @contract = @supplier.contracts.new(cer_code_id: @cer_code.id, price: params[:contract][:price])
    authorize @contract
    if @contract.save
      render action: :reload
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @contract.update(price: params[:contract][:price])
    render action: :reload
  end

  def destroy
    @contract.destroy
    render action: :reload
  end

  private

  def get_contract_and_supplier_and_check_permission
    @contract = Contract.find(params[:id])
    authorize @contract
    @supplier = @contract.supplier
  end
end
