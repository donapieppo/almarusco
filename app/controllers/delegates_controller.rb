class DelegatesController < ApplicationController
  def index
    authorize :delegate
    @delegates = current_organization.permissions.where(authlevel: 20)
  end

  def new
    authorize :delegate
  end

  def create
    begin
      @user = User.syncronize(params[:upn])
      @permission = current_organization.permissions.new(authlevel: 20, user_id: @user.id)
      authorize @permission
      if @permission.save
        redirect_to delegates_path, notice: "È stato aggiunto l'utente #{@user}."
      else
        redirect_to new_delegate_path, alert: "Non è stato possibile salvare l'utente."
      end
    rescue DmUniboCommon::NoUser => e
      skip_authorization
      logger.info(e.to_s)
      redirect_to new_delegate_path, alert: e.to_s
    end
  end
end
