class CirclesController < ApplicationController
  before_action :authenticate_user!

  def index
    @circle_relationships = current_user.circle_members.includes(:member)
  end
end
