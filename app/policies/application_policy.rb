class ApplicationPolicy < DmUniboCommon::ApplicationPolicy
  def current_organization_reader?
    @user && OrganizationPolicy.new(@user, @user.current_organization).read?
  end

  def current_organization_disposer?
    @user && OrganizationPolicy.new(@user, @user.current_organization).dispose?
  end

  def current_organization_manager?
    @user && OrganizationPolicy.new(@user, @user.current_organization).manage?
  end

  def current_organization_admin?
    @user && OrganizationPolicy.new(@user, @user.current_organization).admin?
  end
end
