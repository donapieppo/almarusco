require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Almarusco
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    config.hosts += ENV.fetch("ALLOWED_HOSTS", "").split(",")

    config.time_zone = "Rome"
    config.i18n.default_locale = :it

    config.authlevels = {
      read: 10,
      operate: 20, # operatori
      dispose: 30, # produttori
      manage: 40,  # delegati
      admin: 60    # responsabili ul
    }

    config.action_mailer.default_url_options = {protocol: "https"}
    config.unibo_common = config_for(:unibo_common)
  end
end
