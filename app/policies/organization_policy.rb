class OrganizationPolicy < DmUniboCommon::OrganizationPolicy
  configure_authlevels

  def index?
    @user.is_cesia?
  end

  def status?
    @user.is_cesia? || @user.nuter?
  end

  def read?
    @user && @user.current_organization && @user.authorization.can_read?(@user.current_organization)
  end

  def show?
    @user.is_cesia? || @user.nuter? ||  @user.can_read?(@record)
  end

  def edit?
    update?
  end

  def update?
    @user.is_cesia? || @user.can_manage?(@record)
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
end

