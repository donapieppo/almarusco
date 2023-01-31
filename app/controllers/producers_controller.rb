# sigh, doesn't work without this :-(
require_dependency "dm_unibo_common/permission_policy"

# Producer for almarusco is the person who can dispose.
# Associated to DmUniboCommon::Permission
# maybe refactor < DmUniboCommon::Permission?
class ProducersController < ApplicationController
  def index
    @admin_permissions    = current_organization.permissions.where(authlevel: Rails.configuration.authlevels[:admin]).includes(:user).order('users.surname')
    @manager_permissions  = current_organization.permissions.where(authlevel: Rails.configuration.authlevels[:manage]).includes(:user).order('users.surname')
    @producer_permissions = current_organization.permissions.where(authlevel: Rails.configuration.authlevels[:dispose]).includes(:user).order('users.surname')
    authorize [:dm_unibo_common, :permission]
  end

  def new
    @permission = current_organization.permissions.new(authlevel: Rails.configuration.authlevels[:dispose])
    authorize @permission
  end

  def create
    begin
      @user = User.syncronize(params[:upn])
      @permission = current_organization.permissions.new(authlevel: Rails.configuration.authlevels[:dispose], 
                                                         user_id: @user.id)
      authorize @permission
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
    permission = current_organization.permissions.find_by_id(params[:id]) # DmUniboCommon::Permission
    authorize permission

    if permission.user_id && permission.authlevel == Rails.configuration.authlevels[:dispose] 
      permission.destroy
      # delete also all operators
      current_organization.permissions.where(producer_id: permission.user_id).destroy_all
    end
    redirect_to producers_path
  end
end
