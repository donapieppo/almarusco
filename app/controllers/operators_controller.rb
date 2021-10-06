class OperatorsController < ApplicationController
  before_action :get_producer_and_check_permission

  def new
  end

  # FIXME check operator not already producer in organization
  def create
    begin
      check_producer(@producer)
      @user = User.syncronize(params[:upn])
      @permission = current_organization.permissions.new(authlevel: Rails.configuration.authlevels[:operate], 
                                                         user_id: @user.id,
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
