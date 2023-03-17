class NuterPolicy < ApplicationPolicy
  def charts?
    @user.nuter?
  end

  def report?
    @user.nuter?
  end
end
