class ChangeReceiverInChats < ActiveRecord::Migration
  def change
    rename_column :chats, :receiver, :receiver_id
  end
end
