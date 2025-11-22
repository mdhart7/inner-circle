class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy

 
  has_many :circle_members, dependent: :destroy
  has_many :circle_users, through: :circle_members, source: :member

  
  def full_name
    "#{first_name} #{last_name}".strip.presence || username
  end

  
  def initials
    "#{first_name&.first}#{last_name&.first}".presence ||
      username&.first&.upcase || "?"
  end


  def all_circle_users
    circle_users
  end
end
