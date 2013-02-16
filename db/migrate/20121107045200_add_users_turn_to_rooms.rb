class AddUsersTurnToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :users_turn, :integer
  end
end
