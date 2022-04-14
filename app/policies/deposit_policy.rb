class DepositPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end
end

