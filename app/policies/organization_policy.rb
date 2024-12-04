class OrganizationPolicy < DmUniboCommon::OrganizationPolicy
  configure_authlevels

  def index?
    @user.nuter?
  end

  def status?
    @user.nuter?
  end

  def read?
    @user&.current_organization && (@user.authorization.can_read?(@user.current_organization) || @user.nuter?)
  end

  def show?
    @user.nuter? || @user.can_read?(@record)
  end

  def edit?
    update?
  end

  def update?
    @user.nuter? || @user.can_manage?(@record)
  end

  def destroy?
    @user.is_cesia?
  end

  def choose_organization?
    true
  end

  def dispose?
    @user && @user.authorization.can_operate?(@record)
  end

  # dm_unibo_common/app/policies/dm_unibo_common/organization_policy.rb
  def manage?
    @user && (@user.authorization.can_manage?(@record) || @user.nuter?)
  end
end
