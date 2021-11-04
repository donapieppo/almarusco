class PickingPolicy < ApplicationPolicy
  def index?
    true
  end

  # administrator in some organization
  def create?
    current_organization_manager?
  end

  def update?
    create?
  end

  def print?
    create?
  end
end
