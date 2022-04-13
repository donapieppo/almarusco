class ApplicationPolicy < DmUniboCommon::ApplicationPolicy
  def organization_reader?(o)
    @user && OrganizationPolicy.new(@user, o).read?
  end

  def organization_disposer?(o)
    @user && OrganizationPolicy.new(@user, o).dispose?
  end

  def organization_manager?(o)
    @user && OrganizationPolicy.new(@user, o).manage?
  end

  def organization_admin?(o)
    @user && OrganizationPolicy.new(@user, o).admin?
  end

  def current_organization_reader?
    organization_reader?(@user.current_organization)
  end

  def current_organization_disposer?
    organization_disposer?(@user.current_organization)
  end

  def current_organization_manager?
    organization_manager?(@user.current_organization)
  end

  def current_organization_admin?
    organization_admin?(@user.current_organization)
  end
end
