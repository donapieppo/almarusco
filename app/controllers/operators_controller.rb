# Operator for almarusco is the person who can dispose in the name of a producer.
# Associated to DmUniboCommon::Permission where user_id is the operator and producer_id is the producer
# Note: policy from app/policies/dm_unibo_common/permission_policy.rb
class OperatorsController < ApplicationController
  before_action :get_producer_and_check_permission, only: [:new, :create]

  def new
    @permission = current_organization.permissions.new(authlevel: Rails.configuration.authlevels[:operate]) # DmUniboCommon::Permission
    # see app/policies/dm_unibo_common/permission_policy.rb
    authorize @permission
  end

  # FIXME check operator not already producer in organization
  def create
    if params[:expiry].blank? || params[:upn].blank?
      redirect_to producers_path, alert: "Si prega di fornire e-mail e data di scadenza."
      return
    end
    begin
      check_producer(@producer)
      @user = User.syncronize(params[:upn])
      @permission = current_organization.permissions.new(
        authlevel: Rails.configuration.authlevels[:operate],
        user_id: @user.id,
        expiry: params[:expiry],
        producer_id: @producer.id
      )
      authorize @permission
      old_permission = current_organization.permissions.where(user_id: @user.id, producer_id: @producer.id).first

      if old_permission
        redirect_to producers_path, alert: "Questo utente è già stato associato al produttore."
      elsif @permission.save
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

  def edit
    @permission = current_organization.permissions.find_by_id(params[:id])
    @producer = User.find(@permission.producer_id)
    authorize @permission
  end

  def update
    @permission = current_organization.permissions.find_by_id(params[:id])
    @producer = User.find(@permission.producer_id)
    authorize @permission
    @permission.expiry = params[:expiry]
    if @permission.save
      redirect_to producers_path, notice: "È stato aggiornata la delega a #{@user} per #{@producer}."
    else
      render action: :edit
    end
  end

  def destroy
    permission = current_organization.permissions.find_by_id(params[:id]) # DmUniboCommon::Permission
    authorize permission

    if permission.user_id && permission.authlevel == Rails.configuration.authlevels[:operate]
      permission.destroy
    end
    redirect_to producers_path
  end

  private

  def get_producer_and_check_permission
    @producer = User.find(params[:producer_id])
  end

  def check_producer(p)
    ok = current_organization.permissions
      .where(authlevel: Rails.configuration.authlevels[:dispose], user_id: p.id)
      .any?
    ok or raise DmUniboCommon::NoUser, "Utente no amministratore"
  end
end
