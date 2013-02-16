class AddIndexesToGrids < ActiveRecord::Migration
  def change
    add_index :grids, :coordinate_x
    add_index :grids, :coordinate_y
  end
end
