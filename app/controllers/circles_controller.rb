class CirclesController < ApplicationController
  before_action :authenticate_user!

  def index
    @circle_members = CircleMember
                        .where(user_id: current_user.id, status: "accepted")
                        .includes(:member)

    @incoming_requests = current_user.incoming_requests
  end
end
