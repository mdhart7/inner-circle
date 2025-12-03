class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    friend_ids = current_user.feed_friends.pluck(:id)
    @posts = Post.where(user_id: friend_ids).order(created_at: :desc)
  end
end
