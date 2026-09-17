class PagesController < ApplicationController
  def index
    if user_signed_in?
      friend_ids = current_user.circle_friends_ids

      @polls = Poll.includes(posts: [ :user, :votes, { comments: :user } ])
                   .where(user_id: [ current_user.id ] + friend_ids)
                   .order(created_at: :desc)
    else
      @polls = Poll.none
    end
  end
end
