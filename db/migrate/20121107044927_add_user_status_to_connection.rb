class AddUserStatusToConnection < ActiveRecord::Migration
  def change
    add_column :connections, :user_status, :string
  end
end
