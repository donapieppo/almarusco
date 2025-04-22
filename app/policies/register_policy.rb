class RegisterPolicy < ApplicationPolicy
  def index?
    @user
  end
end
