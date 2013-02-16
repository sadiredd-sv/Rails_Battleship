class CreateGrids < ActiveRecord::Migration
  def change
    create_table :grids do |t|
      t.integer :user_id
      t.string :coordiate
      t.integer :ship_id

      t.timestamps
    end
  end
end
