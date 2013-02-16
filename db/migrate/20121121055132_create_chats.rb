class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.string :message
      t.integer :receiver
      t.integer :user_id
      t.integer :room_id

      t.timestamps
    end
  end
end
