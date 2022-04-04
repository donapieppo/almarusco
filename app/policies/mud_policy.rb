class MudPolicy < ApplicationPolicy
  def show?
    current_organization_manager?
  end
end
