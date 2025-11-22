class CircleMembersController < ApplicationController
  before_action :authenticate_user!

  def create
    input = params[:identifier].to_s.strip.downcase

    if input.blank?
      redirect_to circle_path, alert: "Please enter a username or email."
      return
    end

    
    member = User.where("LOWER(username) = ?", input)
                 .or(User.where("LOWER(email) = ?", input))
                 .first

    unless member
      redirect_to circle_path, alert: "No user found with that username or email."
      return
    end

    if member.id == current_user.id
      redirect_to circle_path, alert: "You cannot add yourself."
      return
    end

    if current_user.circle_members.exists?(member_id: member.id)
      redirect_to circle_path, alert: "#{member.username || member.email} is already in your circle."
      return
    end

    CircleMember.create!(user_id: current_user.id, member_id: member.id)
    redirect_to circle_path, notice: "#{member.username || member.email} added to your circle!"
  end

  def destroy
    cm = current_user.circle_members.find_by(id: params[:id])

    unless cm
      redirect_to circle_path, alert: "Circle member not found."
      return
    end

    cm.destroy
    redirect_to circle_path, notice: "Removed from your circle."
  end
end
