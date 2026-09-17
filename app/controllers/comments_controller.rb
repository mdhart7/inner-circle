class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(user: current_user, body: params[:body])

    if comment.save
      render json: { author: current_user.full_name, body: comment.body }
    else
      render json: { error: comment.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    return head :unauthorized unless comment.user_id == current_user.id

    comment.destroy!
    head :no_content
  end
end
