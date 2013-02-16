class RemoveOccupancyFromRoom < ActiveRecord::Migration
  def up
    remove_column :rooms, :occupancy
  end

  def down
    add_column :rooms, :occupancy, :integer
  end
end
