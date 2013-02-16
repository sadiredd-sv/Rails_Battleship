class AddGameAndRoomRelationship < ActiveRecord::Migration
  def up
    add_column :rooms, :game_id, :integer
    add_index :rooms, :game_id
  end

  def down
    remove_column :rooms, :game_id
    remove_index :rooms, :game_id
  end
end
