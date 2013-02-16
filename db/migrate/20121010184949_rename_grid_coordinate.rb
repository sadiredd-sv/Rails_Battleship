class RenameGridCoordinate < ActiveRecord::Migration
  def up
    rename_column :grids, :coordiate, :coordinate
  end

  def down
  end
end
