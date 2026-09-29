class CreateStyleProfiles < ActiveRecord::Migration[8.0]
  def change
    return if table_exists?(:style_profiles)

    create_table :style_profiles do |t|
      t.bigint :user_id, null: false
      t.string :undertone, null: false   # warm | cool | neutral
      t.string :contrast, null: false    # high | soft
      t.string :eye_color
      t.string :hair_color
      t.timestamps
    end

    add_index :style_profiles, :user_id, unique: true
  end
end
