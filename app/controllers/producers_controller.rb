class ProducersController < ApplicationController
  def index
    authorize :producer
    @producers = current_organization.permissions.where(authlevel: 20).includes(:user).order('users.surname')
  end

  def new
    authorize :producer
  end

  def create
    begin
      @user = User.syncronize(params[:upn])
      @permission = current_organization.permissions.new(authlevel: 20, user_id: @user.id)
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

  def destroy
    @producer = current_organization.permissions.find(params[:id])
    authorize @producer
    @producer.destroy
    redirect_to producers_path, notice: "È stato eliminata la delega come richiesto."
  end
end
