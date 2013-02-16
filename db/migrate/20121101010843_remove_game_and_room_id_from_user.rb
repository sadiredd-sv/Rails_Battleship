class RemoveGameAndRoomIdFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :game_id
    remove_column :users, :room_id
  end

  def down
    add_column :users, :game_id, :integer
    add_column :users, :room_id, :integer
  end
end
