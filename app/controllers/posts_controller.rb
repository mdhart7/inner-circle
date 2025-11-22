class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :vote]
  before_action :set_post, only: [:update, :destroy]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.image = params[:query_image] if params[:query_image].present?

    if @post.save
      redirect_to root_path, notice: "Post created successfully."
    else
      redirect_to root_path, alert: @post.errors.full_messages.to_sentence
    end
  end

  def update
    @post.assign_attributes(post_params)
    @post.image = params[:query_image] if params[:query_image].present?

    if @post.save
      redirect_to root_path, notice: "Post updated."
    else
      redirect_to root_path, alert: @post.errors.full_messages.to_sentence
    end
  end

  def destroy
    return redirect_to(root_path, alert: "Not authorized.") unless @post.user_id == current_user.id

    @post.destroy
    redirect_to root_path, notice: "Post deleted."
  end

  def vote
    post = Post.find(params[:id])
    return render json: { error: "Not authorized" }, status: :unauthorized unless current_user

    vote = post.votes.find_or_initialize_by(user: current_user)
    vote.vote_type = params[:vote_type]

    if vote.save
      render json: {
        total_count: post.total_votes_count,
        yes_count: post.yes_votes_count,
        no_count: post.no_votes_count,
        user_vote: vote.vote_type
      }
    else
      render json: { error: "Vote failed" }, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_path, alert: "Post not found." unless @post
  end

  def post_params
    params.permit(:caption, :image)
  end
end
