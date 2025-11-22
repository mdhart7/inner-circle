class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :vote_type

      t.timestamps
    end

    add_index :votes, [:post_id, :user_id], unique: true
  end
end
