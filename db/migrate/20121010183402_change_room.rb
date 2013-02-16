class ChangeRoom < ActiveRecord::Migration
  def up
    rename_column :rooms, :occpancy, :occupancy
    remove_column :rooms, :game_id
  end

  def down
  end
end
