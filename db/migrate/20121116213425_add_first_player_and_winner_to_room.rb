class AddFirstPlayerAndWinnerToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :first_player, :integer
    add_column :rooms, :current_player, :integer
    add_column :rooms, :winner, :integer
  end
end
