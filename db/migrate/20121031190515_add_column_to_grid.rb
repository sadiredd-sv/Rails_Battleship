class AddColumnToGrid < ActiveRecord::Migration
  def change
    add_column :grids, :alignment, :string
    add_column :grids, :ship_size, :integer
    add_column :grids, :coordinate_x, :integer
    add_column :grids, :coordinate_y, :integer
    add_column :grids, :current_coordinate_x, :integer
    add_column :grids, :current_coordinate_y, :integer
  end

end
