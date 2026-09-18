class HealthController < ApplicationController
  def show
    ActiveRecord::Base.connection.select_value("SELECT 1")
    render plain: "OK", status: :ok
  rescue ActiveRecord::ActiveRecordError => e
    Rails.logger.error("Health check failed: #{e.class} - #{e.message}")
    render plain: "Service unavailable", status: :service_unavailable
  end
end
