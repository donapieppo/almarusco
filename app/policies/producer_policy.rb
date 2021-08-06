class ProducerPolicy < ApplicationPolicy
  def index?
    current_organization_manager?
  end

  def new?
    current_organization_manager?
  end

  # FIXME actually are permissions...
  def create?
    current_organization_manager?
  end

  def destroy?
    current_organization_manager?
  end
end
