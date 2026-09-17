class CreatePollsAndComments < ActiveRecord::Migration[8.0]
  def up
    unless table_exists?(:polls)
      create_table :polls do |t|
        t.integer :user_id
        t.timestamps
        t.index :user_id
      end
    end

    unless table_exists?(:comments)
      create_table :comments do |t|
        t.bigint :post_id
        t.bigint :user_id
        t.text :body
        t.timestamps
        t.index :post_id
        t.index :user_id
      end
    end

    add_column :posts, :poll_id, :integer unless column_exists?(:posts, :poll_id)
    add_index :posts, :poll_id unless index_exists?(:posts, :poll_id)
    add_column :posts, :position, :integer, null: false, default: 0 unless column_exists?(:posts, :position)

    connection.select_all(
      "SELECT id, user_id, created_at, updated_at FROM posts WHERE poll_id IS NULL"
    ).each do |post|
      poll_id = connection.select_value(
        "INSERT INTO polls (user_id, created_at, updated_at) VALUES " \
        "(#{connection.quote(post['user_id'])}, #{connection.quote(post['created_at'])}, " \
        "#{connection.quote(post['updated_at'])}) RETURNING id"
      )
      connection.execute(
        "UPDATE posts SET poll_id = #{connection.quote(poll_id)} " \
        "WHERE id = #{connection.quote(post['id'])}"
      )
    end
  end

  def down
    remove_column :posts, :position
    remove_index :posts, :poll_id if index_exists?(:posts, :poll_id)
    remove_column :posts, :poll_id if column_exists?(:posts, :poll_id)
    drop_table :comments
    drop_table :polls
  end
end
