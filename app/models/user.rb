class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  has_many :circle_members, dependent: :destroy
  has_many :added_users, through: :circle_members, source: :member


  def accepted_friends
    added_users.merge(CircleMember.where(status: "accepted"))
  end

  def incoming_requests
    CircleMember.includes(:user)
                .where(member_id: id, status: "pending")
  end

  # IDs of accepted users I added
  def circle_friends_ids
    CircleMember.where(user_id: id, status: "accepted").pluck(:member_id)
  end

  def feed_friends
    User.where(id: circle_friends_ids)
  end

  def full_name
    "#{first_name} #{last_name}".strip.presence || username
  end

  def initials
    "#{first_name&.first}#{last_name&.first}".presence ||
      username&.first&.upcase || "?"
  end
end
