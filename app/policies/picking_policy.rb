class PickingPolicy < ApplicationPolicy
  def index?
    true
  end

  # administrator in some organization
  def create?
    current_organization_manager?
  end

  def show?
    create?
  end

  def update?
    create?
  end

  def new_print_request?
    create?
  end

  def print_request?
    create?
  end

  def deliver?
    create?
  end

  def complete?
    create?
  end
end
