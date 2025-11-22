# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
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
