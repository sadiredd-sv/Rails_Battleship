class AddByUserToGrid < ActiveRecord::Migration
  def change
    add_column :grids, :shooter_id, :integer
  end
end
