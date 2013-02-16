class AddUpdatedatToConnections < ActiveRecord::Migration
  # Add timestamps into the table so that we can delegate
  # time updating to rails.
  def change
    change_table :connections do |t|
      t.timestamps
    end
  end
end
