class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @posts = Post.order(created_at: :desc)
  end
end
