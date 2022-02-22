# Producer for almarusco is the person who can dispose.
class ProducersController < ApplicationController
  def index
    authorize :producer
    @producers = current_organization.permissions.where(authlevel: Rails.configuration.authlevels[:dispose]).includes(:user).order('users.surname')
  end

  def new
    authorize :producer
  end

  def create
    begin
      @user = User.syncronize(params[:upn])
      @permission = current_organization.permissions.new(authlevel: Rails.configuration.authlevels[:dispose], user_id: @user.id)
      authorize :producer
      if @permission.save
        redirect_to producers_path, notice: "È stato aggiunta la delega a #{@user}."
      else
        redirect_to new_producer_path, alert: "Non è stato possibile salvare l'utente."
      end
    rescue DmUniboCommon::NoUser => e
      skip_authorization
      logger.info(e.to_s)
      redirect_to new_producer_path, alert: e.to_s
    end
  end

  # see app/controllers/operators_controller#destroy
  def destroy
    current_user or raise "NO"
    # DmUniboCommon::Permission
    permission = current_organization.permissions.find_by_id(params[:id])
    producer = permission.user
    # FIXME not allowed to destroy? this DmUniboCommon::Permission
    # even with app/policies with dmDmUniboCommon::Permission
    skip_authorization
    if producer && current_user && 
       OrganizationPolicy.new(current_user, current_organization).admin? &&
       permission.organization_id == current_organization.id && 
       permission.authlevel == Rails.configuration.authlevels[:dispose] 
      permission.destroy
      current_organization.permissions.where(producer_id: producer.id).destroy_all
    end
    redirect_to producers_path
  end
end
