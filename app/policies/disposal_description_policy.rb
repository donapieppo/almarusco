class DisposalDescriptionPolicy < ApplicationPolicy
  def index?
    current_organization_disposer?
  end

  def show?
    current_organization_disposer?
  end

  def create?
    current_organization_disposer?
  end

  def update?
    current_organization_disposer?
  end
end
