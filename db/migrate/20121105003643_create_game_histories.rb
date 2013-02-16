class CreateGameHistories < ActiveRecord::Migration
  def change
    create_table :game_histories do |t|
      t.integer :room_id
      t.integer :turn_no
      t.integer :attacker_id
      t.integer :target_id
      t.integer :coordinate_x
      t.integer :coordinate_y
      t.string :status

      t.timestamps
    end
  end
end
