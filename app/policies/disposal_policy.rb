class DisposalPolicy < ApplicationPolicy
  def index?
    current_organization_disposer? || @user.nuter?
  end

  def show?
    @user.owns?(@record) || @user.id == @record.producer_id || organization_manager?(@record.organization)
  end

  def choose_disposal_type?
    current_organization_disposer?
  end

  def new?
    current_organization_disposer?
  end

  def create?
    organization_disposer?(@record.organization)
  end

  def clone?
    new?
  end

  def update?
    @user && ((!@record.approved? && @record.undelivered? && @user.owns?(@record)) || organization_manager?(@record.organization))
  end

  # ONLY MANAGER and only not delivered FIXME puo' succedere il contrario?
  def destroy?
    update? && @record.undelivered?
  end

  def approve?
    !@record.approved? && organization_manager?(@record.organization)
  end

  def unapprove?
    @record.approved? && !@record.legalized? && organization_manager?(@record.organization)
  end

  def search?
    @user
  end

  def archive?
    organization_manager?(@record.organization)
  end

  def legalize?
    current_organization_manager?
  end
end
