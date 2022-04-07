class OperatorsController < ApplicationController
  before_action :get_producer_and_check_permission, only: [:new, :create]

  def new
  end

  # FIXME check operator not already producer in organization
  def create
    begin
      check_producer(@producer)
      @user = User.syncronize(params[:upn])
      @permission = current_organization.permissions.new(authlevel: Rails.configuration.authlevels[:operate], 
                                                         user_id: @user.id,
                                                         expiry: params[:expiry], 
                                                         producer_id: @producer.id)
      if @permission.save
        redirect_to producers_path, notice: "È stato aggiunta la delega a #{@user} per #{@producer}."
      else
        redirect_to new_producer_path, alert: "Non è stato possibile salvare l'utente."
      end
    rescue DmUniboCommon::NoUser => e
      skip_authorization
      logger.info(e.to_s)
      redirect_to producers_path, alert: e.to_s
    end
  end

  # see app/controllers/producers_controller#destroy
  def destroy
    current_user or raise "NO"
    # DmUniboCommon::Permission
    permission = current_organization.permissions.find_by_id(params[:id])
    # FIXME not allowed to destroy? this DmUniboCommon::Permission
    # even with app/policies with dmDmUniboCommon::Permission
    skip_authorization
    if current_user && 
       OrganizationPolicy.new(current_user, current_organization).admin? &&
       permission.organization_id == current_organization.id && 
       permission.authlevel == Rails.configuration.authlevels[:operate] 
      permission.destroy
    end
    redirect_to producers_path
  end

  private

  def get_producer_and_check_permission
    @producer = User.find(params[:producer_id])
    authorize :operator
  end

  def check_producer(p)
    ok = current_organization.permissions.where(authlevel: Rails.configuration.authlevels[:dispose],
                                                user_id: p.id).any?
    ok or raise DmUniboCommon::NoUser, "Utente no amministratore"
  end
end
