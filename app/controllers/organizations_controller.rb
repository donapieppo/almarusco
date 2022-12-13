class OrganizationsController < ApplicationController
  # only cesia from _menu
  def index
    authorize Organization
    @organizations = Organization.order(:id).includes(permissions: :user)
  end

  def status
    authorize Organization
    @organizations = Organization.order(:id).includes(permissions: :user)
    @counts = Disposal.group(:organization_id).count
  end

  def show
    authorize Organization
    @organization = Organization.find(params[:id])
    render layout: nil
  end

  def edit
    authorize current_organization
    @permissions_hash = permissions_hash
  end

  def update
    authorize current_organization
    if current_organization.update(organization_params)
      redirect_to current_organization_edit_path, notice: 'La Struttura è stata modificata.'
    else
      @permissions_hash = permissions_hash
      render action: :edit, status: :unprocessable_entity
    end
  end

  def choose_organization
    authorize Organization
  end

  private

  def organization_params
    p =  [:adminmail]
    p += [:name, :description, :code] if current_user.is_cesia?
    params[:organization].permit(p)
  end

  def permissions_hash
    res = Hash.new { |hash, key| hash[key] = [] }
    current_organization.permissions.includes(:user).order('authlevel desc, users.upn asc').references(:user).each do |permission|
      res[permission.authlevel] << permission
    end
    res
  end
end
