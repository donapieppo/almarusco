class DmUniboCommon::PermissionPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end

  def create?
    organization_manager?(@record.organization) || @user.nuter?
  end

  def update?
    organization_manager?(@record.organization) || @user.nuter?
  end

  def destroy?
    organization_manager?(@record.organization) || @user.nuter?
  end
end
