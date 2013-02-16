class AddSalvoToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :salvo, :integer
  end
end
