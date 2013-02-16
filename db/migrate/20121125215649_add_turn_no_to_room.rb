class AddTurnNoToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :turn_no, :integer
  end
end
