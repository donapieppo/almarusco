class SupplierPolicy < ApplicationPolicy
  def index?
    true
  end

  # administrator in some organization
  def create?
    @user.nuter?
  end

  def update?
    @user.nuter?
  end
end
