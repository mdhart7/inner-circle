class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_referral, if: :devise_controller?

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_up_path_for(resource)
    complete_referral(resource)
    root_path
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

  def store_referral
    referral = params[:ref].to_s.strip.downcase
    session[:referral_username] = referral if referral.present?
  end

  def complete_referral(resource)
    username = session.delete(:referral_username)
    return if username.blank? || resource.username.blank? || username == resource.username.downcase

    referrer = User.find_by("LOWER(username) = ?", username)
    return unless referrer

    CircleMember.find_or_initialize_by(user: referrer, member: resource).update!(status: "accepted")
    CircleMember.find_or_initialize_by(user: resource, member: referrer).update!(status: "accepted")
  end
end
