class DepositPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end

  def to_legalize?
    current_organization_manager?
  end
end

