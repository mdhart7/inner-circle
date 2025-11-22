class CircleMember < ApplicationRecord
  belongs_to :user
  belongs_to :member, class_name: "User"

  validates :member_id, uniqueness: { scope: :user_id }
end
