class DisposalPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user.owns?(@record) || @user.id == @record.producer_id || @user.can_manage?(@record.organization_id)
  end

  def choose_disposal_type?
    current_organization_disposer?
  end

  def create?
    current_organization_disposer?
  end

  def update?
    @user && ((! @record.approved? && @record.undelivered? && @user.owns?(@record)) || OrganizationPolicy.new(@user, @record.organization_id).manage?)
  end

  # ONLY MANAGER and only not delivered FIXME puo' succedere il contrario?
  def destroy?
    update? && @record.undelivered?
  end

  def approve?
    OrganizationPolicy.new(@user, @record.organization_id).manage?
  end

  def unapprove?
    approve?
  end

  def search?
    @user
  end

  def archive?
    current_organization_manager?
  end
end
