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
    if !current_user || !current_organization || !OrganizationPolicy.new(current_user, current_organization).dispose?
      skip_authorization
      redirect_to home_path(__org__: nil), alert: "Non hai accesso alla risorsa richiesta."
    end
  end

  def set_locale
    I18n.locale = :it
  end
end
