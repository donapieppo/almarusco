class PickingDocumentPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
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

  def print?
    create?
  end

  def deliver?
    create?
  end
end