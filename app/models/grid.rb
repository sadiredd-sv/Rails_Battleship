class Grid < ActiveRecord::Base
  attr_accessible :ship_id, :status, :ship_size, :alignment, :coordinate_x, :coordinate_y,
                  :current_coordinate_x, :current_coordinate_y, :grid_type, :shooter_id


  #validates :ship_id, presence: true
  #validates :alignment, presence: true
  validates :coordinate_x, presence: true
  validates :coordinate_y, presence: true
  validates :grid_type, presence: true
  #validates :current_coordinate_x, presence: true
  #validates :current_coordinate_y, presence: true

  belongs_to :user
  belongs_to :room

  OTHER_GRID_ATTRS = Battleship::Application::OTHER_GRID_ATTRS
  OWN_GRID_ATTRS = Battleship::Application::OWN_GRID_ATTRS

  def self.find_by_room_and_user(room, user)
    # Check it there is any grid belongs to the given room and user
    where("user_id = ? AND room_id = ?", user.id, room.id)
  end

  def self.find_by_room_and_user?(room, user)
    # Check it there is any grid belongs to the given room and user
    where("user_id = ? AND room_id = ?", user.id, room.id).size > 0
  end

  def fire(x,y)

  end

  def to_hash_with_shooter
    grid_attrs = self.attributes.select { |key,v| OWN_GRID_ATTRS.include?(key) }
    grid_attrs['shooter'] = User.find(self.shooter_id) unless self.shooter_id.nil?
    grid_attrs
  end

  def to_hash_with_shooter_remove_types
    # Filter out some room attributes
    grid_attrs = self.attributes.select { |key,v| OTHER_GRID_ATTRS.include?(key) }
    grid_attrs['shooter'] = User.find(self.shooter_id) unless self.shooter_id.nil?
    grid_attrs
  end
end
