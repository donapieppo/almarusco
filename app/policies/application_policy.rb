class ApplicationPolicy < DmUniboCommon::ApplicationPolicy
  def organization_disposer?(o)
    @user && OrganizationPolicy.new(@user, o).dispose?
  end

  def current_organization_disposer?
    organization_disposer?(@user.current_organization)
  end

  def current_organization_manager?
    @user && (organization_manager?(@user.current_organization) || @user.nuter?)
  end
end
