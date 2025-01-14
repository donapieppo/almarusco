class CompliancesController < ApplicationController
  before_action :set_compliance_and_check_permission, only: [:show, :edit, :update, :destroy]

  def index
    authorize :compliance
    @compliances = current_organization.compliances.order(:name)
    @common_compliances = Compliance.where("organization_id is NULL").order(:name)
  end

  def new
    @compliance = current_organization.compliances.new(year: Date.today.year)
    authorize @compliance
  end

  def create
    common = params[:compliance].delete(:common)
    @compliance = current_organization.compliances.new(compliance_params)

    if current_user.nuter? && common == 1
      @compliance.organization_id = nil
      @compliance.document = nil
    end

    authorize @compliance
    if @compliance.save
      redirect_to compliances_path, notice: "OK."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    # can not change organization_id and common
    if @compliance.update(compliance_params)
      redirect_to compliances_path, notice: "OK."
    end
  end

  def destroy
    authorize @compliance
    @compliance.destroy
    redirect_to compliances_path, notice: "Omologa cancellata correttamente."
  end

  private

  def set_compliance_and_check_permission
    @compliance = Compliance.find(params[:id])
    authorize @compliance
  end

  def compliance_params
    params.require(:compliance).permit(:id, :name, :description, :year, :url, :document)
  end
end
