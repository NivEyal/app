# frozen_string_literal: true
require_relative 'boot'

require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'rails/health_controller'

require_relative '../lib/api_path_consider_json_middleware'
require_relative '../lib/normalize_client_ip_middleware'

Bundler.require(*Rails.groups)

module DocuSeal
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks puma])

    # I18n settings
    config.i18n.available_locales = %i[en en-US en-GB es-ES fr-FR pt-PT de-DE it-IT es it de fr pl uk cs pt he nl ar ko]
    config.i18n.fallbacks = [:en]

    # Middleware
    config.middleware.insert_before ActionDispatch::Static, Rack::Deflater
    config.middleware.insert_before ActionDispatch::Static, NormalizeClientIpMiddleware
    config.middleware.insert_before ActionDispatch::Static, ApiPathConsiderJsonMiddleware

    # Disable ActiveRecord
    config.generators.orm = nil

    # Disable system tests since they might assume ActiveRecord exists
    config.generators.system_tests = nil

    ActiveSupport.run_load_hooks(:application_config, self)
  end
end
