class AddIndexToUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :name, using: :gin, opclass: :gin_trgm_ops
  end
end
