class ProducerPolicy < ApplicationPolicy
  def index?
    @user && (@user.nuter? || OrganizationPolicy.new(@user, @user.current_organization).manage?)
  end
end
