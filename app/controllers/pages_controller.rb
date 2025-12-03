class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    circle_user_ids = current_user.added_users.pluck(:id)
    @posts = Post.where(user_id: circle_user_ids).order(created_at: :desc)
  end
end
