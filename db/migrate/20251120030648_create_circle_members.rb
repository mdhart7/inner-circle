class CreateCircleMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :circle_members do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :member, null: false, foreign_key: { to_table: :users, on_delete: :cascade }

      t.timestamps
    end

    add_index :circle_members, [:user_id, :member_id], unique: true
  end
end
