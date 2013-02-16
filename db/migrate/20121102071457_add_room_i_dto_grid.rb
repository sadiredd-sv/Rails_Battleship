class AddRoomIDtoGrid < ActiveRecord::Migration
  def up
    add_column :grids, :room_id, :integer
  end

  def down
  end
end
