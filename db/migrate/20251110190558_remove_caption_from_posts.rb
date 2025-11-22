class RemoveCaptionFromPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :posts, :caption, :text
  end
end
