class ApplicationController < DmUniboCommon::ApplicationController
  include DmUniboCommon::Controllers::Helpers

  before_action :set_current_user,
    :update_authorization,
    :force_sso_user,
    :set_current_organization,
    :log_current_user,
    :after_current_user_and_organization,
    :set_locale

  def after_current_user_and_organization
    if !current_user || !current_organization || !(OrganizationPolicy.new(current_user, current_organization).dispose? || current_user.nuter?)
      skip_authorization
      redirect_to home_path(__org__: nil), alert: "Non hai accesso alla risorsa richiesta."
      return
    end
    @alert_permissions = current_user.permissions.where(organization_id: current_organization.id).where("expiry < ?", Date.today + 40.days).load
  end

  def set_locale
    I18n.locale = :it
  end
end
