class HealthController < ApplicationController
  # Keep the automated health check independent of the database so it does not
  # keep an otherwise idle Neon compute instance awake.
  def show
    render plain: "OK", status: :ok
  end

  # Use manually when debugging database connectivity; do not schedule it.
  def db
    ActiveRecord::Base.connection.select_value("SELECT 1")
    render plain: "OK", status: :ok
  rescue ActiveRecord::ActiveRecordError => e
    Rails.logger.error("Health check failed: #{e.class} - #{e.message}")
    render plain: "Service unavailable", status: :service_unavailable
  end
end
