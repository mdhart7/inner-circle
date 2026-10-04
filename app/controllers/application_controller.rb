class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :remember_referral

  protected

  def can_see_post?(post)
    post.user_id == current_user.id || current_user.circle_friends_ids.include?(post.user_id)
  end

  def after_sign_in_path_for(resource)
    complete_referral(resource, pending_referral)
    stored_location_for(resource) || root_path
  end

  def after_sign_up_path_for(resource)
    complete_referral(resource, pending_referral)
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name, :last_name, :username
    ])

    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, :last_name, :username
    ])

    devise_parameter_sanitizer.permit(:sign_in, keys: [ :login ])
  end

  def remember_referral
    referral = params[:ref].to_s.strip
    session[:referrer_username] = referral if referral.present? && !user_signed_in?
  end

  def pending_referral
    remembered_referral = session.delete(:referrer_username)
    params[:ref].presence || remembered_referral
  end

  def complete_referral(resource, referral)
    username = referral.to_s.strip.downcase
    return if username.blank? || resource.username.blank? || username == resource.username.downcase

    referrer = User.find_by("LOWER(username) = ?", username)
    return unless referrer

    CircleMember.find_or_initialize_by(user: referrer, member: resource).update!(status: "accepted")
    CircleMember.find_or_initialize_by(user: resource, member: referrer).update!(status: "accepted")
  end
end
