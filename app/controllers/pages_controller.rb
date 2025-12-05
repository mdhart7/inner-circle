class PagesController < ApplicationController
  def index
    if user_signed_in?
      friend_ids = current_user.circle_friends_ids
      @posts = Post.where(user_id: friend_ids).order(created_at: :desc)
    else
      @posts = Post.none
    end
  end
end
