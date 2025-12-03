class CircleMembersController < ApplicationController
  before_action :authenticate_user!

  def create
    identifier = params[:identifier].to_s.strip.downcase

    if identifier.blank?
      redirect_to circle_path, alert: "Please enter an email or username." and return
    end

    member = User.where("LOWER(email) = ?", identifier)
                 .or(User.where("LOWER(username) = ?", identifier))
                 .first

    if member.nil?
      redirect_to circle_path, alert: "User not found." and return
    end

    if member.id == current_user.id
      redirect_to circle_path, alert: "You cannot add yourself." and return
    end

    existing = CircleMember.find_by(user_id: current_user.id, member_id: member.id)
    if existing
      redirect_to circle_path, alert: "Already added or pending." and return
    end

    CircleMember.create!(
      user_id: current_user.id,
      member_id: member.id,
      status: "pending"
    )

    redirect_to circle_path, notice: "Request sent to #{member.full_name}."
  end

  def accept
    cm = CircleMember.find(params[:id])

    unless cm.member_id == current_user.id
      redirect_to circle_path, alert: "Unauthorized." and return
    end

    cm.update!(status: "accepted")

    CircleMember.find_or_create_by!(
      user_id: current_user.id,
      member_id: cm.user_id,
      status: "accepted"
    )

    redirect_to circle_path, notice: "Request accepted!"
  end

  def destroy
    cm = CircleMember.find(params[:id])

    unless cm.user_id == current_user.id || cm.member_id == current_user.id
      redirect_to circle_path, alert: "Unauthorized." and return
    end

    CircleMember.where(
      user_id: [cm.user_id, cm.member_id],
      member_id: [cm.user_id, cm.member_id]
    ).destroy_all

    redirect_to circle_path, notice: "Removed from circle."
  end
end
