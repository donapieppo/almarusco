class CompliancesController < ApplicationController
  before_action :set_compliance_and_check_permission, only: [:show, :edit, :update, :destroy]

  def index
    authorize :compliance
    @organization_compliances = current_organization.compliances.order(:name)
    @common_compliances = Compliance.where("organization_id is NULL").order(:name)
  end

  def new
    @compliance = current_organization.compliances.new(year: Date.today.year)
    authorize @compliance
  end

  def create
    common = params[:compliance].delete(:common)
    @compliance = current_organization.compliances.new(compliance_params)

    if current_user.nuter? && common.to_i > 0
      @compliance.organization_id = nil
      @compliance.document = nil
    end

    authorize @compliance
    if @compliance.save
      redirect_to compliances_path, notice: "Omologa salvata correttamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    # can not change between omologa di ateneo / omologa di ul
    @protect_type = true
  end

  def update
    # can not change organization_id and common
    if @compliance.update(compliance_params)
      redirect_to compliances_path, notice: "Omologa aggiornata correttamente."
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
