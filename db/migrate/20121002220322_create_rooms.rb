class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :size
      t.integer :occpancy

      t.timestamps
    end
  end
end
