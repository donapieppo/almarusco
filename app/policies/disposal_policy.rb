class DisposalPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user.owns?(@record) || @user.can_manage?(@record.organization_id)
  end

  def choose_disposal_type?
    current_organization_disposer?
  end

  def create?
    current_organization_disposer?
  end

  def update?
    @user && (@user.owns?(@record) || OrganizationPolicy.new(@user, @record.organization_id).manage?)
  end

  # ONLY MANAGER
  def destroy?
    OrganizationPolicy.new(@user, @record.organization_id).manage?
  end

  def approve?
    @user && OrganizationPolicy.new(@user, @record.organization_id).manage?
  end
end
