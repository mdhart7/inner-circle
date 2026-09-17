class CleanupOldPostsJob < ApplicationJob
  queue_as :background

  def perform
    retention_days = ENV.fetch("POST_RETENTION_DAYS", "90").to_i
    cutoff = retention_days.days.ago

    Post.where("created_at < ?", cutoff).destroy_all
  end
end
