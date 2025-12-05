class CircleMembersController < ApplicationController
  before_action :authenticate_user!

  def create
    input = params[:identifier].to_s.strip.downcase
    return redirect_to circle_path, alert: "Please enter a username or email." if input.blank?

    member = User.where("LOWER(username) = ?", input)
                 .or(User.where("LOWER(email) = ?", input))
                 .first

    return redirect_to circle_path, alert: "User not found." unless member
    return redirect_to circle_path, alert: "You cannot add yourself." if member == current_user

    existing = CircleMember.find_by(user_id: current_user.id, member_id: member.id)
    return redirect_to circle_path, alert: "Already added or pending." if existing

    CircleMember.create!(
      user: current_user,
      member: member,
      status: "pending"
    )

    redirect_to circle_path, notice: "Request sent to #{member.full_name}."
  end


  def accept
    cm = CircleMember.find(params[:id])

    # Only the person who RECEIVED the request may accept it
    unless cm.member_id == current_user.id
      return redirect_to circle_path, alert: "Unauthorized."
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
      return redirect_to circle_path, alert: "Unauthorized."
    end

    CircleMember.where(
      user_id: [cm.user_id, cm.member_id],
      member_id: [cm.user_id, cm.member_id]
    ).destroy_all

    redirect_to circle_path, notice: "Removed from circle."
  end
end
