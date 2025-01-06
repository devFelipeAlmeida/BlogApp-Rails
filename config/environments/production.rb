require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:         "smtp.gmail.com",
    port:            587,
    domain:          "blogapp-rails.fly.dev",
    user_name:       ENV["SMTP_USERNAME"],
    password:        ENV["SMTP_PASSWORD"],
    authentication:  "plain",
    enable_starttls: true,
    open_timeout:    5,
    read_timeout:    5
  }
  config.enable_reloading = false

  config.action_mailer.default_url_options = { host: 'blogapp-rails.fly.dev', protocol: 'https' }

  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.active_storage.service = :production

  config.assets.compile = false

  config.active_storage.service = :local

  config.force_ssl = true

  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  config.active_record.dump_schema_after_migration = false

  config.active_record.attributes_for_inspect = [ :id ]
end
