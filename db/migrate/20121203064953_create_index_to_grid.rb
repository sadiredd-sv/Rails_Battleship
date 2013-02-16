class CreateIndexToGrid < ActiveRecord::Migration
  def up
    add_index :grids, :grid_type
    add_index :grids, :status
    add_index :grids, :user_id
    add_index :grids, :room_id
  end

  def down
  end
end
