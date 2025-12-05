require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Production behavior
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  config.action_controller.perform_caching = true

  config.public_file_server.headers = {
    "cache-control" => "public, max-age=#{1.year.to_i}"
  }

  # ActiveStorage (Cloudinary recommended)
  config.active_storage.service = :local

  # SSL
  config.assume_ssl = true
  config.force_ssl = true

  # Logging
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.silence_healthcheck_path = "/up"

  config.active_support.report_deprecations = false

  config.cache_store = :solid_cache_store
  config.active_job.queue_adapter = :solid_queue

  # MAILER — REQUIRED FOR DEVISE
  config.action_mailer.default_url_options = {
    host: ENV.fetch("APP_HOST", "your-render-url.onrender.com")
  }

  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false

  # Content-Security-Policy patch
  config.content_security_policy do |policy|
    policy.frame_ancestors :self, "https://envoy.fyi"
  end
end
