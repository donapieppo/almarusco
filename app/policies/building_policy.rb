class BuildingPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end

  def show?
    current_organization_manager?
  end

  def new?
    @user.is_cesia?
  end

  def create?
    @user.is_cesia?
  end

  def update?
    @user.is_cesia?
  end

  def destroy?
    @user.is_cesia?
  end
end
