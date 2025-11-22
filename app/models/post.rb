class Post < ApplicationRecord
  belongs_to :user

  mount_uploader :image, ImageUploader

  has_many :votes, dependent: :destroy

  def yes_votes_count
    votes.where(vote_type: "yes").count
  end

  def no_votes_count
    votes.where(vote_type: "no").count
  end

  def total_votes_count
    votes.count
  end

  def user_vote(current_user)
    return nil unless current_user
    votes.find_by(user_id: current_user.id)
  end
end
