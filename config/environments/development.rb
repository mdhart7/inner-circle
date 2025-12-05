require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Allow all hosts for development
  config.hosts.clear

  # Enable BetterErrors / Web Console
  config.web_console.allowed_ips = "0.0.0.0/0"
  BetterErrors::Middleware.allow_ip! "0.0.0.0/0"

  # Reload code automatically
  config.enable_reloading = true
  config.eager_load = false

  # Show full errors
  config.consider_all_requests_local = true

  # Caching toggle
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "cache-control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Local file storage
  config.active_storage.service = :local

  # Mailer defaults
  config.action_mailer.default_url_options = {
    host: "localhost",
    port: 3000
  }

  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true

  config.active_job.verbose_enqueue_logs = true
  config.active_job.queue_adapter = :solid_queue

  # Disable forgery check for POST requests (codespaces/dev only)
  config.action_controller.forgery_protection_origin_check = false

  # View Debugging
  config.action_view.annotate_rendered_view_with_filenames = true
end
