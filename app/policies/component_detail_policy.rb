class ComponentDetailPolicy < ApplicationPolicy
  # FIXME
  def create?
    @user.nuter? || (@user && @user.owns?(@record.disposal_description))
  end

  # FIXME
  def update?
    @user.nuter? || (@user && @user.owns?(@record.disposal_description))
  end
end
