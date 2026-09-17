class CreatePollsAndComments < ActiveRecord::Migration[8.0]
  def up
    create_table :polls do |t|
      t.integer :user_id
      t.timestamps
      t.index :user_id
    end

    create_table :comments do |t|
      t.bigint :post_id
      t.bigint :user_id
      t.text :body
      t.timestamps
      t.index :post_id
      t.index :user_id
    end

    add_column :posts, :poll_id, :integer
    add_index :posts, :poll_id
    add_column :posts, :position, :integer, null: false, default: 0

    select_all("SELECT id, user_id, created_at, updated_at FROM posts").each do |post|
      poll_id = select_value(
        "INSERT INTO polls (user_id, created_at, updated_at) VALUES " \
        "(#{quote(post['user_id'])}, #{quote(post['created_at'])}, #{quote(post['updated_at'])}) RETURNING id"
      )
      execute("UPDATE posts SET poll_id = #{quote(poll_id)} WHERE id = #{quote(post['id'])}")
    end
  end

  def down
    remove_column :posts, :position
    remove_index :posts, :poll_id
    remove_column :posts, :poll_id
    drop_table :comments
    drop_table :polls
  end
end
