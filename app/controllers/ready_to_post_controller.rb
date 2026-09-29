class ReadyToPostController < ApplicationController
  before_action :authenticate_user!

  def index
    @my_polls = current_user.polls
                             .includes(posts: [ :votes, :cover_votes ])
                             .order(created_at: :desc)
                             .limit(20)
  end
end
