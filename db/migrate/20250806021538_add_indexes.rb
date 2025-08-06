class AddIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :follows, :follower_id # for individual indexing
    add_index :follows, :followed_id # for individual indexing

    add_index :follows, :deleted_at  # for query because we use soft delete
    add_index :users,   :deleted_at  # for query because we use soft delete
  end
end
