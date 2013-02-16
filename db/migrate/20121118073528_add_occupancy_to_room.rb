class AddOccupancyToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :occupancy, :integer
  end
end
