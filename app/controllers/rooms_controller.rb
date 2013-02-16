class RoomsController < ApplicationController
  include SessionsHelper
  before_filter :signed_in_user

  USER_STATUS = Battleship::Application::USER_STATUS
  ROOM_STATUS = Battleship::Application::ROOM_STATUS
  INCLUDE_USERS = {include: {users: {only: [:name, :email, :created_at, :id]}}, except: [:created_at, :updated_at, ] }

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
    room_list = []
    @rooms.each do |room|
      room_list << room.to_hash_with_users(current_user)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: room_list.to_json}
    end
  end

  # GET /rooms/list
  def list
    @rooms = Room.all
    room_list = []
    @rooms.each do |room|
      room_list << room.to_hash_with_users(current_user)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: room_list.to_json}
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @room = current_user.rooms.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room.to_hash_with_users(current_user).to_json }
    end
  end

  # GET /rooms/new
  def new
    @room = current_user.rooms.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/1/edit
  def edit
    @room = current_user.rooms.find(params[:id])
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = current_user.rooms.create({name: params[:room][:name],
                                       max_user: params[:room][:max_user],
                                       host_id: current_user.id,
                                       salvo: params[:room][:salvo],
                                       occupancy: 1
                                      })
    @room.set_user_status(current_user, USER_STATUS[:join])
    @room.status = ROOM_STATUS[:open]
    # Broadcast a message
    channel = "server_channel"
    respond_message = {
        message: "a room created",
    }

    self.broadcast_message_to_channel(channel, :room_created, respond_message)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render json:  @room.to_hash_with_users(current_user).to_json, status: :created, location: @room }
      else
        format.html { render action: "new" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end

  end

  # PUT /rooms/1
  # PUT /rooms/1.json
  def update
    # Filter only those valid to be updated
    updated_attributes = {}
    updated_attributes[:name] =  params[:room][:name]
    updated_attributes[:max_user] =  params[:room][:max_user]
    @room = current_user.rooms.find(params[:id])

    respond_to do |format|
      if @room.update_attributes(updated_attributes)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render json: @room.to_hash_with_users(current_user).to_json }
      else
        format.html { render action: "edit" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room = current_user.rooms.find(params[:id])
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { head :no_content }
    end
  end

  # A user can join a particular room.
  def join
    # Check status first to see if the user can join.
    # Check if the number of users exceed the the size of the room.
    @room = Room.find(params[:id])

    # Room is oversize
    if @room.is_full?
      message = "#{current_user.name} cannot joined the room because the room is full."
      result = false
    elsif @room.status != ROOM_STATUS[:open]
      message = "The room #{params[:id]} is not open!"
    elsif @room.join?(current_user)
      message = "#{current_user.name} is already joinned the room"
    else

      result = @room.join(current_user)
      if result
        message = "#{current_user.name} has joined the room"
      else
        message = "#{current_user.name} cannot join the room. Server side error"
      end
    end

    if result
      channel = params[:id].to_s
      respond_message = {
          message:  message,
          current_user: current_user,
          room_id: @room.id,
          status: USER_STATUS[:join]
      }
      self.broadcast_message_to_channel(channel, :user_status, respond_message)
    else
      channel = "server_channel"
      self.broadcast_message_to_channel(channel, :user_status, respond_message)
    end

    respond_to do |format|
      if result
        format.html { redirect_to @room, notice: message }
        format.json { render json:  @room.to_hash_with_users(current_user).to_json, status: :created, location: @room }
      else
        format.html { render notice: "Cannot join the room." }
        format.json { render json: {message: message}, status: :unprocessable_entity }
      end
    end
  end

  # A user can leave a particular room.
  def leave
    # Check status first to see if the user can join.
    # Check if the number of users exceed the the size of the room.
    @room = Room.find(params[:id])
    result = @room.leave(current_user)
    if result
      channel = params[:id].to_s
      respond_message = {
          message: "has left the room",
          current_user: current_user,
          room_id: @room.id,
          status: USER_STATUS[:leave]
      }
      self.broadcast_message_to_channel(channel, :user_status, respond_message)
    end

    respond_to do |format|
      if result
        format.html { redirect_to list_rooms_path, notice: 'Successfully left the room.' }
        format.json { render json:  @room.to_hash_with_users(current_user).to_json }
      else
        format.html { redirect_to list_rooms_path }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /room/:id/ready
  def ready
    @room = Room.find(params[:id])
    result = @room.ready(current_user)
    if result
      channel = params[:id].to_s
      respond_message = {
          message: "Ready to play. Let's go!",
          current_user: current_user,
          room_id: @room.id,
          status: USER_STATUS[:ready]
      }
      self.broadcast_message_to_channel(channel, :user_status, respond_message)
    else
      # Already ready
      # Do nothing
    end

    # Check the size of user who is ready

    result = @room.everyone_ready?

    if(result)
      respond_message = {
          message: "Start Timer",
          current_user: {name: 'server', id: nil},
          room_id: @room.id,
      }
      self.broadcast_message_to_channel(channel, :start_timer, respond_message)
    end




    respond_to do |format|
      #if result
      format.html { redirect_to list_rooms_path, notice: 'Ready to play' }
      format.json { render json:  @room.to_hash_with_users(current_user).to_json }
      #else
      #  format.html { redirect_to list_rooms_path }
      #  format.json { render json: @room.errors, status: :unprocessable_entity }
      #end
    end
  end

  # POST /room/1/deploy_ships
  def deploy_ships
    # TODO: Change the status of the grids
    logger.debug(params[:id])
    @room = Room.find(params[:id])
    ## Make sure that the user havs not deployed yet
    ## TODO remove this
    #if Grid.find_by_room_and_user?(@room, current_user)
    #  # Delete and first
    #  Room.transaction do
    #    Grid.find_by_room_and_user(@room, current_user).each do |grid|
    #      grid.delete
    #    end
    #  end
    #end

    channel = params[:id]
    # The use is able to deploy when the status is 'ready'
    if @room.user_status(current_user) == USER_STATUS[:ready]
      # Create new grid records
      ship_array = params[:ship][:ship_array]
      @room.save_grid_array(current_user, ship_array)

      # Broadcast to all user about status
      message = "Deployed ships"
    else
      message = "Cannot deploy ships"
    end

    # Change the status of the room to be "locked"
    @room.status = ROOM_STATUS[:locked]
    @room.save

    respond_message = {
      message: message,
      current_user: current_user,
      room_id: @room.id,
      status: USER_STATUS[:ready]
    }

    self.broadcast_message_to_channel(channel, :user_status, respond_message)

    # If all users already deployed, broadcast to the channel that the game is running turn
    if (@room.all_users_deploy?)
      #
      @room.init_game_play

      respond_message = {
          message: 'game_play',
          current_user: {name: 'server', id: nil},
          room_id: @room.id,
      }
      self.broadcast_message_to_channel(channel, :game_play, respond_message)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { head :no_content }
    end
  end

  # POST
  # {"salvo":{"targets":[{"user_id":11,"x":2,"y":8},{"user_id":11,"x":3,"y":8},{"user_id":11,"x":4,"y":8}],"customURL":"/rooms/70/fire"}}
  def fire
    @room = current_user.rooms.find(params[:id])
    targets = params[:salvo][:targets]
    if @room.current_player == current_user.id
      @room.fire_targets(targets, current_user)
      # Update the turn
      @room.update_turnno()
      # If successfully updated, change the turn; otherwise, it is the end of the game
      if @room.winner == nil
        # Broadcast a message
        channel = params[:id].to_s
        respond_message = {
            message: "Fire",
            current_user: current_user,
            room_id: @room.id,
            status: USER_STATUS[:ready]
        }
        self.broadcast_message_to_channel(channel, :change_turn, respond_message)
      else
        # Broadcast a message
        channel = params[:id].to_s
        respond_message = {
            message: "End of game",
            current_user: current_user,
            room_id: @room.id
            #status: USER_STATUS[:ready]
        }
        self.broadcast_message_to_channel(channel, :game_end, respond_message)
      end
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def play
    @room = Room.find(params[:id])

    respond_to do |format|
      format.html # paly.html.erb

    end

  end

  # Return the status of game play

  def game_status
    results = {}
    @room = @room = current_user.rooms.find(params[:id])
    @users = @room.users
    results = @room.to_json
    game_status = @room.game_status
    respond_to do |format|
      format.json { render json: game_status }
    end
  end

  def list_users
    @room = current_user.rooms.find(params[:id])
    results = @room.user_room_status

    respond_to do |format|
      format.json { render json: results }
    end

  end

  # GET /rooms/:id/grids_list
  def grid_list
    @grids = current_user.grids.where(room_id: params[:id])
    results = []
    @grids.each do |grid|
      results << grid.to_hash_with_shooter
    end
    respond_to do |format|
      format.json { render json: results.to_json }
    end
  end

  def grid_list_by_user
    @room = current_user.rooms.find(params[:id])
    user = @room.users.find(params[:user_id])
    results = []

    if user != nil
      puts "===========================================", user
      # Id the user is lost, show all the ship
      if @room.user_status(user) == USER_STATUS[:lost]
        @grids = user.grids.where(room_id: params[:id])
        @grids.each do |grid|
          results << grid.to_hash_with_shooter
        end
      else
        # Else remove type of grid (ship or water)
        @grids = user.grids.where(room_id: params[:id])
        @grids.each do |grid|
          results << grid.to_hash_with_shooter_remove_types
        end
      end
    end

    respond_to do |format|
      format.json { render json: results.to_json }
    end
  end

  # GET /rooms/:id/ship_list
  def ship_list
    @room = current_user.rooms.find(params[:id])
    @grid = @room.to_ship_list(current_user)
    respond_to do |format|
      format.json { render json: @grid }
    end
  end

  # Broacast a message to a channel with specific event
  def broadcast_message_to_channel(channel, event, message)
    # Convert channel to string so that websocket is able to convert it to a symbol
    channel_sym = channel.to_s
    WebsocketRails[channel_sym].trigger(event, message)
  end

  private
    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
end
