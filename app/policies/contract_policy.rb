class ContractPolicy < ApplicationPolicy
  # administrator in some organization
  def create?
    current_organization_manager?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
