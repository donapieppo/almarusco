class DisposalTypePolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user && current_organization_manager?
  end

  def create?
    @user && current_organization_manager?
  end

  def clone?
    create?
  end

  def update?
    @user && OrganizationPolicy.new(@user, @record.organization_id).manage?
  end

  def destroy?
    @user && OrganizationPolicy.new(@user, @record.organization_id).manage? && @record.disposals.empty?
  end
end
