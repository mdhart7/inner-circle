class CirclesController < ApplicationController
  before_action :authenticate_user!

  def index
    @circle_members = current_user.circle_members.where(status: "accepted")

    @incoming_requests = current_user.incoming_requests
  end
end
