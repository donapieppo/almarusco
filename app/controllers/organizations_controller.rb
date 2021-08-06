class OrganizationsController < ApplicationController
  # only cesia from _menu
  def index
    authorize Organization
    @organizations = Organization.order(:id).includes(permissions: :user)
  end

  def edit
    authorize current_organization

    @permissions_hash = Hash.new { |hash, key| hash[key] = [] }

    current_organization.permissions.includes(:user).order('authlevel desc, users.upn asc').references(:user).each do |permission|
      @permissions_hash[permission.authlevel] << permission
    end
  end

  def update
    authorize current_organization
    if current_organization.update(organization_params)
      redirect_to current_organization_edit_path, notice: 'La Struttura è stata modificata.'
    else
      render action: :edit
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
end
