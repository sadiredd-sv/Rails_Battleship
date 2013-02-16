class GameHistory < ActiveRecord::Base
  attr_accessible :attacker_id, :coordinate_x, :coordinate_y, :room_id, :status, :target_id, :turn_no
  belongs_to :room
end
