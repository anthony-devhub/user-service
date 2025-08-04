class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto'

    create_table :users, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
