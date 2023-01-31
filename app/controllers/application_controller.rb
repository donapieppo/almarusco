class ApplicationController < DmUniboCommon::ApplicationController
  include DmUniboCommon::Controllers::Helpers

  before_action :set_current_user, :update_authorization, :set_current_organization, :log_current_user, :force_sso_user, :after_current_user_and_organization, :set_locale
  after_action :verify_authorized, except: [:who_impersonate, :impersonate, :stop_impersonating]

  def after_current_user_and_organization
    if ! current_user || ! current_organization || ! OrganizationPolicy.new(current_user, current_organization).dispose?
      skip_authorization
      redirect_to dm_unibo_common.no_access_path
      return
    end
  end

  def set_locale
    I18n.locale = :it
  end
end
