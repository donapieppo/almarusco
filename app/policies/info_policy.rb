class InfoPolicy < ApplicationPolicy
  def index?
    @user && current_organization_manager?
  end
end

