class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    existing_vote = current_user.votes.find_by(post_id: post.id)
    
    if existing_vote
      
      existing_vote.update(vote_type: params[:vote_type])
    else
      
      current_user.votes.create(
        post_id: post.id,
        vote_type: params[:vote_type]
      )
    end
    
    
    render json: {
      yes_count: post.yes_votes_count,
      no_count: post.no_votes_count,
      total_count: post.total_votes_count,
      user_vote: params[:vote_type]
    }
  end
  
  def destroy
    vote = current_user.votes.find(params[:id])
    vote.destroy
    
    post = Post.find(vote.post_id)
    
    render json: {
      yes_count: post.yes_votes_count,
      no_count: post.no_votes_count,
      total_count: post.total_votes_count,
      user_vote: nil
    }
  end
end
