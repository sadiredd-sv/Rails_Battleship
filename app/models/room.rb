class Room < ActiveRecord::Base
  attr_accessible :occupancy, :max_user, :status, :name, :host_id, :first_player, :current_player, :winner, :turn_no, :salvo
  has_many :connections
  has_many :users, through: :connections
  has_many :grids
  has_many :game_histories
  has_many :chats

  validates :name, presence: true, length: { maximum: 50 }
  validates :host_id, presence: true
  validates :max_user, :numericality => {:greater_than => 1, :message => "the max players should be 2 at least."}
  validates :max_user, :numericality => {:less_than => 9, :message => "max players allowed is 8."}
  #scope :user_in_room_status,

  #before_create :edit_occupancy
  #before_save :edit_occupancy
  #before_update :edit_occupancy

  scope :users_turn, order('updated_at desc')

  USER_FILTER = Battleship::Application::USER_FILTER
  USER_STATUS = Battleship::Application::USER_STATUS
  GRID_STATUS = Battleship::Application::GRID_STATUS
  GRID_SIZE = Battleship::Application::GRID_SIZE
  GRID_TYPE = Battleship::Application::GRID_TYPE
  ROOM_STATUS = Battleship::Application::ROOM_STATUS

  # Automatically update the number of users in the room
  def edit_occupancy
    self.occupancy = self.users.size
  end

  # Return true if the user joined the room
  def join?(user)
    # Update the room -> user based on user_id

    # return true if the user can join the room; otherwise false
    users.include?(user)
  end

  # Add the room the given user
  def join(user)
    # Check if the user already joined the room or the room is open
    if not self.join?(user) and not self.is_full? and self.status == ROOM_STATUS[:open]
      self.users << user
      self.set_user_status(user, USER_STATUS[:join])
      self.edit_occupancy
      return  self.save
    else
      return false
    end
  end

  # Delete the user from the room
  def leave(user)
    if self.status == ROOM_STATUS[:open]
      if self.join?(user)
        # Delete existing grids
        Room.transaction do
          self.grids.where(user_id: user.id).each do |grid|
            grid.delete
          end
          self.users.delete(user)
        end
        self.edit_occupancy
        self.save
      end
    elsif self.status == ROOM_STATUS[:locked]
      # during the game play; mark the status in the connection table
      self.set_user_status(user, USER_STATUS[:leave])
    else  self.status == ROOM_STATUS[:finished]
      # Do nothing
      false
    end
  end

  def is_full?
    self.users.size >= self.max_user
  end

  def ready(user)
    if self.join?(user)
      if self.user_status(user) == USER_STATUS[:join]
        self.set_user_status(user, USER_STATUS[:ready])
      end
    end
  end

  '''
  Return the number of users who already joined the room
  '''
  def occupancy
    users.size
  end

  # Set the status of the user given
  def set_user_status(user, status)
    if self.users.find(user.id)
      connection_record = self.connections.where(user_id:  "#{user.id}")
      conn = connection_record[0]
      conn.user_status = status
      conn.save
    else
      "The user is not in the room"
    end
  end

  # Get the status of the user given
  def user_status(user)
    if self.users.find(user.id)
      connection_record = self.connections.where(user_id:  "#{user.id}")
      connection_record[0].user_status
    else
        "The user is not in the room"
    end
  end

  # Get user status and room status
  def user_room_status
    results = []
    self.users.each do |user|
      user_json = {}
      user_json[:name] = user.name
      user_json[:email] = user.email
      user_json[:status] = self.user_status(user)
      results << user_json
    end
    results
  end

  # Return true if the users in the room are all ready.
  def all_users_ready?
    ready = true
    self.users.each do |user|
      if self.user_status(user) != USER_STATUS[:ready]
        ready = false
      end
    end
    # return ready
    ready
  end

  # Return true if the users in the room are all ready.
  def everyone_ready?
    count=0
    self.users.each do |user|
      if self.user_status(user) != USER_STATUS[:ready]
        return false
      else
      #count to make sure game doesn't start when only one player is ready
        count=count+1;
      end
    end
    # return ready
    count >=2
  end

  # Return true if all the users in the room all deploy
  def all_users_deploy?
    ready = true
    self.users.each do |user|
      if self.user_status(user) != USER_STATUS[:deploy]
        ready = false
      end
    end
    # return ready
    ready
  end

  def save_grid_array(user, ship_array)
    # Create ship grids
    Room.transaction do
      ship_array.each do |grid_attrs|
        ship_grid = self.grids.new grid_attrs
        ship_grid.user = user
        ship_grid.status = nil
        ship_grid.grid_type = 'ship'
        ship_grid.save

      end

      # Change the user status
      self.set_user_status(user, USER_STATUS[:deploy])

      # Create water grids
      (0..GRID_SIZE-1).each do |x|
        (0..GRID_SIZE-1).each do |y|
          # No grid there
          if self.grids.where(user_id: user.id, coordinate_x: x, coordinate_y: y).size == 0
            grid = self.grids.new({coordinate_x: x, coordinate_y: y, grid_type: 'water'})
            grid.user = user
            grid.status = nil
            grid.save
          end
        end
      end
    end
  end

  # Get hash with user attributes
  def to_hash_with_users(current_user)
    users = []
    self.users.each do |user|
      u = user.attributes.select { |key,v| USER_FILTER.include?(key) }
      u['status'] = self.user_status(user)
      users << u
    end
    rooms_attrs = self.attributes
    rooms_attrs['users'] = users
    rooms_attrs['current_user'] = current_user

    rooms_attrs
  end

  # Override as json method
  def as_json(options = nil)
    super(options ||
          {include: {users: {only: [:name, :email, :created_at]}},
           except: [:created_at, :updated_at, ]})
  end

  # Get a list of a given users
  def to_ship_list(current_user)
    #@grid = current_user.grids.where(room_id: params[:id])
    grids = self.grids.where(user_id: current_user.id)
    results = []
    grids.each do |grid|
      if grid.coordinate_x == grid.current_coordinate_x and grid.coordinate_y == grid.current_coordinate_y
        results << grid
      end
    end
    results
  end

  """
  {
    turn_id: 1
    user_turn: 1,
    users: [
      {user_id: 1, grids: []}
      {user_id: 2, grids: []}
    ]
    game_history: []
  """
  # Create a structure of the game so that it can refresh in one request
  def game_status

    status_results = {}
    users_json = []

    self.users.each do |user|
      u = user.attributes.select { |key,v| USER_FILTER.include?(key) }
      u['grids'] = self.get_user_grids(user.id)
      users_json << u
    end

    status_results['users'] = users_json
    status_results
  end

  # This will return the user list by update_at asc
  def get_turn_order
    self.connections.select('user_id').where(user_status: USER_STATUS[:deploy]).order('updated_at asc')
  end

  # init the game
  def init_game_play
    user_order = self.get_turn_order[0]
    if user_order
      self.first_player = user_order['user_id']
      self.current_player = user_order['user_id']
      self.turn_no = 0
      self.save
    end

  end

  # Get the next user based on the current_player
  def get_next_user
    index = 0
    i = 0
    self.get_turn_order.each do |conn|
      puts "-------------",self.current_player,conn.user_id
      if self.current_player == conn.user_id
        index = i
      end
      i += 1
    end

    if get_turn_order.size > 0
      # Get next index
      index += 1
      user_index = index % self.get_turn_order.size
      self.get_turn_order[user_index].user_id
    else
      nil
    end
  end

  # Update the turn of game play
  def update_turnno
    # Increase turn number
    self.turn_no += 1
    while true
      # Change user turn
      self.current_player = self.get_next_user
      self.save
      # Check status
      break if self.current_player == nil
      user  = self.users.find(current_player)
      break if self.user_status(user) != USER_STATUS[:lost] or USER_STATUS[:leave]
    end
  end

  # return true if all of his ships get sunk
  def all_ships_sunk?(user)
    all_ship = self.grids.where(user_id: user.id, grid_type: 'ship').size
    sunk_ships = self.grids.where(status: "hit", user_id: user.id, grid_type: 'ship').size
    all_ship == sunk_ships
  end

  def get_user_grids(user)
    self.grids.last
  end

  def fire_targets(targets, shooter)
    targets.each do |target|
      # Update user grids
      targeted_user = self.users.find(target[:user_id])
      x = target[:x]
      y = target[:y]
      status = GRID_STATUS[:missed]
      targeted_grids = self.grids.where(user_id: targeted_user.id, coordinate_x: x, coordinate_y: y)
      if (targeted_grids.size > 0)
        # Found the grid
        targeted_grid = targeted_grids[0]
        targeted_grid.status = GRID_STATUS[:missed]
        if targeted_grid.grid_type == GRID_TYPE[:ship]
          targeted_grid.status = GRID_STATUS[:hit]
          status = GRID_STATUS[:hit]
        end
        targeted_grid.shooter_id = shooter.id
        targeted_grid.save

      end

      # Update game history
      history = self.game_histories.build(
          attacker_id: shooter.id,
          coordinate_x: x,
          coordinate_y: y,
          status: status,
          target_id: targeted_user.id,
          turn_no: self.turn_no
      )

      history.save
    end

    # Update user status
    self.users.each do |user|
      if self.all_ships_sunk?(user)
        puts 'found user got sunk!'
        self.set_user_status(user, USER_STATUS[:lost])
        user.save
      end
    end

    ## Find the winner
    if self.connections.select('user_id').where(user_status: 'lost').size + 1 == self.connections.select('user_id').size
      winner = self.connections.select('user_id').where('user_status <> "'+ USER_STATUS[:lost] + '"' )
      if winner.size > 0
        self.winner = winner[0].user_id
        user_winner = self.users.find(winner[0].user_id)
        self.set_user_status(user_winner, USER_STATUS[:won])
        self.status = ROOM_STATUS[:finished]
        self.save
      end
    end

  end

end
