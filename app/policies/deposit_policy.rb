class DepositPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end

  def legalize?
    current_organization_manager?
  end
end

