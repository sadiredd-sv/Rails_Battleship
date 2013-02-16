class AddGridTypeToGrid < ActiveRecord::Migration
  def change
    add_column :grids, :grid_type, :string
  end
end
