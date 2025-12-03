class CircleMembersController < ApplicationController
  before_action :authenticate_user!


  def create
    identifier = params[:identifier]&.strip
    member = User.find_by(email: identifier) || User.find_by(username: identifier)

    if member.nil?
      redirect_to circle_path, alert: "User not found."
      return
    end

    if member.id == current_user.id
      redirect_to circle_path, alert: "You cannot add yourself."
      return
    end

    existing = CircleMember.find_by(user_id: current_user.id, member_id: member.id)

    if existing
      redirect_to circle_path, alert: "Already added or pending."
      return
    end

    CircleMember.create!(
      user: current_user,
      member: member,
      status: "pending"
    )

    redirect_to circle_path, notice: "Request sent to #{member.full_name}."
  end

  
  def accept
    cm = CircleMember.find(params[:id])
    
    if cm.member_id != current_user.id
      redirect_to circle_path, alert: "Unauthorized"
      return
    end

    cm.update(status: "accepted")

    CircleMember.find_or_create_by!(
      user_id: current_user.id,
      member_id: cm.user_id,
      status: "accepted"
    )

    redirect_to circle_path, notice: "Request accepted!"
  end


  def destroy
    cm = CircleMember.find(params[:id])

    if cm.user_id == current_user.id || cm.member_id == current_user.id
      # Remove both directions
      CircleMember.where(
        user_id: [cm.user_id, cm.member_id],
        member_id: [cm.user_id, cm.member_id]
      ).destroy_all

      redirect_to circle_path, notice: "Removed from circle."
    else
      redirect_to circle_path, alert: "Unauthorized."
    end
  end
end
