class CompliancePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    @user.nuter? || organization_manager?(@record.organization)
  end

  def update?
    @user.nuter? || organization_manager?(@record.organization)
  end
end
