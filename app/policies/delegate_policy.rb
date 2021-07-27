class DelegatePolicy < ApplicationPolicy
  def index?
    @user
  end

  def create?
    @user
  end

  def destroy?
    @user
  end
end
