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

  def yes_votes_count
    votes.loaded? ? votes.count { |vote| vote.vote_type == "yes" } : votes.where(vote_type: "yes").count
  end

  def no_votes_count
    votes.loaded? ? votes.count { |vote| vote.vote_type == "no" } : votes.where(vote_type: "no").count
  end

  def total_votes_count
    votes.loaded? ? votes.length : votes.count
  end

  def user_vote(current_user)
    return nil unless current_user
    votes.loaded? ? votes.find { |vote| vote.user_id == current_user.id } : votes.find_by(user_id: current_user.id)
  end
end
