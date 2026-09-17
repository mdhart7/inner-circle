class Poll < ApplicationRecord
  belongs_to :user
  has_many :posts, -> { order(position: :asc) }, dependent: :destroy

  def carousel?
    posts.size > 1
  end
end
