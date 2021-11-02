class UnCodePolicy < ApplicationPolicy
  def index?
    true
  end

  # administrator in some organization
  def create?
    current_organization_manager?
  end

  def update?
    current_organization_manager?
  end
end
