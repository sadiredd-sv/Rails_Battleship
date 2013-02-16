class CreateConnection < ActiveRecord::Migration
  def up
    create_table :connections do |t|
      t.integer :user_id
      t.integer :room_id
    end

    add_index :connections, :user_id
    add_index :connections, :room_id
  end

  def down
    drop_table :connections
  end
end
