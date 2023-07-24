class DmUniboCommon::PermissionPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end

  def create?
    organization_manager?(@record.organization)
  end

  def update?
    organization_manager?(@record.organization)
  end

  def destroy?
    organization_manager?(@record.organization)
  end
end
