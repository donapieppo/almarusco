class PickingDocumentPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end

  # administrator in some organization
  def create?
    current_organization_manager?
  end

  def show?
    current_organization_manager?
  end

  def update?
    if @record && @record.picking.completed?
      return false
    end
    @record && current_organization_manager?
  end

  def print?
    show?
  end
end
