class DisposalTypePolicy < ApplicationPolicy
  def index?
    @user
  end

  def create?
    @user && current_organization_manager?
  end

  def update?
    @user && OrganizationPolicy.new(@user, @record.organization_id).admin?
  end
end
