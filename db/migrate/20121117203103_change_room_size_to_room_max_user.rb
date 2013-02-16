class ChangeRoomSizeToRoomMaxUser < ActiveRecord::Migration
  def change
    rename_column :rooms, :size, :max_user
  end
end
