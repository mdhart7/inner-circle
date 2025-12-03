class AddStatusToCircleMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :circle_members, :status, :string, default: "pending"
  end
end
