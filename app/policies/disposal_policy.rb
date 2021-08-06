class DisposalPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user
  end

  def choose_disposal_type?
    @user
  end

  def create?
    @user
  end

  def update?
    @user
  end

  def approve?
    @user
  end
end
