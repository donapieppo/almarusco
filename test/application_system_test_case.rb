require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :headless, screen_size: [1400, 1400]
  Capybara.default_driver = :selenium_headless

  def set_current_user_and_organization(auth=:operate)
    @current_user = FactoryBot.create(:user, id: 1000)
    @current_organization = FactoryBot.create(:organization)
    @current_organization.permissions.create(user: @current_user, authlevel: Rails.configuration.authlevels[auth])
  end
end
