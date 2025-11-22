class CirclesController < ApplicationController
  before_action :authenticate_user!

  def index
    @circle_members = current_user.all_circle_users
  end
end
