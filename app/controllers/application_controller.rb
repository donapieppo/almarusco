class ApplicationController < DmUniboCommon::ApplicationController
  include DmUniboCommon::Controllers::Helpers

  before_action :set_current_user, :update_authorization, :set_current_organization, :log_current_user, :force_sso_user, :check_current_organization, :set_locale
  after_action :verify_authorized, except: [:who_impersonate, :impersonate, :stop_impersonating]

  def check_current_organization
    if ! current_organization
      redirect_to no_access_path
    end
  end

  def set_locale
    I18n.locale = :it
  end
end
