class Poll < ApplicationRecord
  belongs_to :user
  has_many :posts, -> { order(position: :asc) }, dependent: :destroy
  has_many :cover_votes, dependent: :destroy

  def carousel?
    posts.size > 1
  end

  # The photo with the most cover picks. Ties go to the earlier photo.
  # Returns nil until at least one person has picked a cover.
  def cover_post
    return nil unless carousel?

    leader = posts.max_by { |post| [ post.cover_votes_count, -post.position ] }
    leader if leader && leader.cover_votes_count.positive?
  end

  # Best-rated photos in this set: most yes votes first, then fewest no
  # votes, then original order.
  def top_posts(limit = 3)
    posts.sort_by { |post| [ -post.yes_votes_count, post.no_votes_count, post.position ] }.first(limit)
  end
end
