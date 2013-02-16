class CreateUsers < ActiveRecord::Migration
  '''
  We maintain a users belonging to one game and one room at a time.
  The relation between user model and others are:
    User (1) --- (1) Game
    User (1) --- (1) Room
    User (1) --- (M) Deployments
  '''
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :game_id
      t.integer :room_id

      t.timestamps
    end

    # Add index to improve performance 
    add_index :users, :game_id
    add_index :users, :room_id
  end
end
