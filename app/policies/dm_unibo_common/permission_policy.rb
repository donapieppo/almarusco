class DmUniboCommon::PermissionPolicy
  def index?
    current_organization_manager?
  end

  def create?
    organization_manager?(@record.organization)
  end

  def update?
    organization_manager?(@record.organization)
  end
end
