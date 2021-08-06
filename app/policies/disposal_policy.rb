class DisposalPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user.owns?(@record) || @user.can_manage?(@record.organization_id)
  end

  def choose_disposal_type?
    current_organization_reader?
  end

  def create?
    @user && OrganizationPolicy.new(@user, @user.current_organization).dispose?
  end

  def update?
    @user && (@user.owns?(@record) || OrganizationPolicy.new(@user, @record.organization_id).manage?)
  end

  def approve?
    @user && OrganizationPolicy.new(@user, @record.organization_id).manage?
  end
end
