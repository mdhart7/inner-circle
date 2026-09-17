class CreatePollsAndComments < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE TABLE IF NOT EXISTS polls (
        id bigserial PRIMARY KEY,
        user_id integer,
        created_at timestamp(6) NOT NULL,
        updated_at timestamp(6) NOT NULL
      )
    SQL
    execute "CREATE INDEX IF NOT EXISTS index_polls_on_user_id ON polls (user_id)"

    execute <<~SQL
      CREATE TABLE IF NOT EXISTS comments (
        id bigserial PRIMARY KEY,
        post_id bigint,
        user_id bigint,
        body text,
        created_at timestamp(6) NOT NULL,
        updated_at timestamp(6) NOT NULL
      )
    SQL
    execute "CREATE INDEX IF NOT EXISTS index_comments_on_post_id ON comments (post_id)"
    execute "CREATE INDEX IF NOT EXISTS index_comments_on_user_id ON comments (user_id)"

    execute "ALTER TABLE posts ADD COLUMN IF NOT EXISTS poll_id integer"
    execute "CREATE INDEX IF NOT EXISTS index_posts_on_poll_id ON posts (poll_id)"
    execute "ALTER TABLE posts ADD COLUMN IF NOT EXISTS position integer NOT NULL DEFAULT 0"

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
    remove_column :posts, :position if column_exists?(:posts, :position)
    remove_index :posts, :poll_id if index_exists?(:posts, :poll_id)
    remove_column :posts, :poll_id if column_exists?(:posts, :poll_id)
    drop_table :comments, if_exists: true
    drop_table :polls, if_exists: true
  end
end
