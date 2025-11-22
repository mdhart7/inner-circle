# == Schema Information
#
# Table name: votes
#
#  id         :bigint           not null, primary key
#  vote_type  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  user_id    :integer
#
# Indexes
#
#  index_votes_on_post_id_and_user_id  (post_id,user_id) UNIQUE
#
class Vote < ApplicationRecord
  belongs_to :post
  belongs_to :user
  
  validates :vote_type, inclusion: { in: ['yes', 'no'] }
  validates :user_id, uniqueness: { scope: :post_id }
end
