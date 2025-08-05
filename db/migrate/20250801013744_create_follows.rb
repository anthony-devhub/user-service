class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :follower_id, null: false
      t.uuid :followed_id, null: false

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :follows, [ :follower_id, :followed_id ], unique: true
    add_foreign_key :follows, :users, column: :follower_id
    add_foreign_key :follows, :users, column: :followed_id
  end
end
