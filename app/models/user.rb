class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  has_many :circle_members, dependent: :destroy
  has_many :added_users, through: :circle_members, source: :member

  def accepted_circle_users
    User.joins(:circle_members)
        .where(circle_members: { user_id: id, status: "accepted" })
  end

  def incoming_requests
    CircleMember.where(member_id: id, status: "pending")
  end

  def full_name
    "#{first_name} #{last_name}".strip.presence || username
  end

  def initials
    "#{first_name&.first}#{last_name&.first}".presence ||
      username&.first&.upcase || "?"
  end

  def feed_friends
    accepted_circle_users
  end
end
