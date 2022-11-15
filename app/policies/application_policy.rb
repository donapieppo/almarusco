class ApplicationPolicy < DmUniboCommon::ApplicationPolicy
  def organization_disposer?(o)
    @user && OrganizationPolicy.new(@user, o).dispose?
  end

  def current_organization_disposer?
    organization_disposer?(@user.current_organization)
  end
end
