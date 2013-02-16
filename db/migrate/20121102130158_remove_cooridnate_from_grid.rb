class RemoveCooridnateFromGrid < ActiveRecord::Migration
  def up
    remove_column :grids, :coordinate
  end

  def down
  end
end
