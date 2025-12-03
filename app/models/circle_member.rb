# == Schema Information
#
# Table name: circle_members
#
#  id         :bigint           not null, primary key
#  status     :string           default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_circle_members_on_member_id              (member_id)
#  index_circle_members_on_user_id                (user_id)
#  index_circle_members_on_user_id_and_member_id  (user_id,member_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (member_id => users.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class CircleMember < ApplicationRecord
  belongs_to :user
  belongs_to :member, class_name: "User"

  validates :member_id, uniqueness: { scope: :user_id }
  
end
