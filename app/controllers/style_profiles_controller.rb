class StyleProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @style_profile = current_user.style_profile
  end

  def update
    @style_profile = current_user.style_profile || current_user.build_style_profile
    @style_profile.assign_attributes(profile_params)

    if @style_profile.save
      redirect_to "/style", notice: "Your style profile is set."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.permit(:undertone, :contrast, :eye_color, :hair_color)
  end
end
