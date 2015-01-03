require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kazimirski
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr
    config.i18n.available_locales = :fr

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.x.captchas = [   {:text => "DANS L'IDIOME", :uuid => "9ad39f73-7b80-4013-809c-6945dbd23355"},
                            {:text => "TOME PREMIER", :uuid => "ffa971d9-f127-408b-88c4-7c734b7ddfbd"},
                            {:text => "TOUTES LES RACINES", :uuid => "71074c5e-e3ee-4b04-85ef-6a860f55828a"} ]

  end
end
