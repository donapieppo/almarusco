class LabPolicy < ApplicationPolicy
  def index?
    current_organization_manager? || @user.nuter?
  end

  def show?
    index?
  end

  def create?
    current_organization_manager? || @user.nuter?
  end

  def update?
    current_organization_manager? || @user.nuter?
  end

  def destroy?
  end
end
