class ApplicationController < DmUniboCommon::ApplicationController
  include DmUniboCommon::Controllers::Helpers

  before_action :set_current_user, :update_authorization, :set_current_organization, :log_current_user, :force_sso_user
  after_action :verify_authorized, except: [:who_impersonate, :impersonate, :stop_impersonating]

  def set_locale
    I18n.locale = :it
  end

  def current_user_producer?
    current_user.authorization.authlevel(current_organization) == Rails.configuration.authlevels[:dispose]
  end

  def current_user_operator?
    current_user.authorization.authlevel(current_organization) == Rails.configuration.authlevels[:operate]
  end
end
