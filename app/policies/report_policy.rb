class ReportPolicy < ApplicationPolicy
  def index?
    @user.nuter?
  end
end
