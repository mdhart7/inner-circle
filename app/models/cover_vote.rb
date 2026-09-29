# One person's "cover" pick for a set of photos (a Poll). Each person gets a
# single pick per set: starring a different photo moves their pick, and
# starring the same photo again removes it.
class CoverVote < ApplicationRecord
  belongs_to :poll
  belongs_to :post
  belongs_to :user

  validates :user_id, uniqueness: { scope: :poll_id }
end
