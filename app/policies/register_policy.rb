class RegisterPolicy < ApplicationPolicy
  def index?
    @user
  end

  def create?
    @user && current_organization_manager?
  end
end
