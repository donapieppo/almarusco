class LegalRecordPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end

  def create?
    current_organization_manager?
  end

  def update?
    current_organization_manager?
  end

  def todo?
    current_organization_manager?
  end
  
  def show?
    current_organization_manager?
  end
end
