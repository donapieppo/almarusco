require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Almarusco
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1
    config.unibo_common = config_for(:unibo_common)

    config.hosts << config.unibo_common.host

    config.time_zone = "Rome"
    config.i18n.default_locale = :it

    config.authlevels = {
      read: 10,
      operate: 20, # operatori
      dispose: 30, # produttori
      manage: 40,  # delegati
      admin: 60    # responsabili ul
    }

    config.active_storage.variant_processor = :disabled

    Rails.application.routes.default_url_options = {
      host: config.unibo_common.host,
      protocol: "https"
    }
  end
end
