# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :poll, optional: true

  mount_uploader :image, ImageUploader

  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :cover_votes, dependent: :destroy

  def yes_votes_count
    votes.loaded? ? votes.count { |vote| vote.vote_type == "yes" } : votes.where(vote_type: "yes").count
  end

  def no_votes_count
    votes.loaded? ? votes.count { |vote| vote.vote_type == "no" } : votes.where(vote_type: "no").count
  end

  def total_votes_count
    votes.loaded? ? votes.length : votes.count
  end

  def cover_votes_count
    cover_votes.loaded? ? cover_votes.size : cover_votes.count
  end

  def covered_by?(user)
    return false unless user

    cover_votes.loaded? ? cover_votes.any? { |cover_vote| cover_vote.user_id == user.id } : cover_votes.exists?(user_id: user.id)
  end

  # Small square version for thumbnails. Cloudinary resizes on the fly when
  # the transformation is added to the delivery URL, so small grids don't
  # download full-size photos.
  def thumb_url(size = 240)
    url = image.url
    return url if url.blank?

    url.sub("/upload/", "/upload/c_fill,w_#{size},h_#{size},q_auto,f_auto/")
  end

  def user_vote(current_user)
    return nil unless current_user
    votes.loaded? ? votes.find { |vote| vote.user_id == current_user.id } : votes.find_by(user_id: current_user.id)
  end
end
