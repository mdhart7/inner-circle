class CreateCoverVotes < ActiveRecord::Migration[8.0]
  def change
    return if table_exists?(:cover_votes)

    create_table :cover_votes do |t|
      t.bigint :poll_id, null: false
      t.bigint :post_id, null: false
      t.bigint :user_id, null: false
      t.timestamps
    end

    add_index :cover_votes, [ :poll_id, :user_id ], unique: true
    add_index :cover_votes, :post_id
  end
end
