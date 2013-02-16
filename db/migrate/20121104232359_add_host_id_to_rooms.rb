class AddHostIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :host_id, :string
  end
end
