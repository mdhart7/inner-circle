class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :update, :destroy, :vote, :cover ]
  before_action :set_post, only: [ :update, :destroy ]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def create
    images = Array(params[:query_images] || params[:query_image]).flatten.compact
    images.select!(&:present?)
    return redirect_to(root_path, alert: "Please choose at least one photo.") if images.blank?

    Poll.transaction do
      poll = current_user.polls.create!
      images.each_with_index do |image, index|
        poll.posts.create!(
          post_params.merge(position: index, user: current_user, image: image)
        )
      end
    end

    redirect_to root_path, notice: "Post created successfully."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: e.record.errors.full_messages.to_sentence
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

    @post.poll ? @post.poll.destroy : @post.destroy
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

  # Star a photo as the "cover" pick for its set. One pick per person per set:
  # starring another photo moves the pick, starring the same one removes it.
  def cover
    post = Post.find(params[:id])
    poll = post.poll

    unless poll&.carousel? && can_see_poll?(poll)
      return render json: { error: "Cover picks are only available on photo sets you can see." }, status: :forbidden
    end

    existing = poll.cover_votes.find_by(user_id: current_user.id)

    if existing&.post_id == post.id
      existing.destroy
    elsif existing
      existing.update!(post: post)
    else
      poll.cover_votes.create!(post: post, user: current_user)
    end

    render json: cover_payload(Poll.includes(posts: :cover_votes).find(poll.id))
  end

  private

  def can_see_poll?(poll)
    poll.user_id == current_user.id || current_user.circle_friends_ids.include?(poll.user_id)
  end

  def cover_payload(poll)
    my_pick = poll.posts.find { |post| post.covered_by?(current_user) }

    {
      cover_post_id: poll.cover_post&.id,
      my_pick_post_id: my_pick&.id,
      counts: poll.posts.to_h { |post| [ post.id, post.cover_votes_count ] }
    }
  end

  def set_post
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_path, alert: "Post not found." unless @post
  end

  def post_params
    params.permit(:caption, :image)
  end
end
