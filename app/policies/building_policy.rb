class BuildingPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end

  def show?
    current_organization_manager?
  end

  def new?
    @user.nuter?
  end

  def create?
    @user.nuter?
  end

  def update?
    @user.nuter?
  end

  def destroy?
    @user.nuter?
  end
end
