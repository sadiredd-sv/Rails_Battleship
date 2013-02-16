class AddStatusToGrid < ActiveRecord::Migration
  def change
    add_column :grids, :status, :string
  end
end
