class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @posts = Post.order(created_at: :desc)
    end
  end

  def index
    friend_ids = current_user.circle_friends_ids
    @posts = Post.where(user_id: friend_ids).order(created_at: :desc)
  end
end
