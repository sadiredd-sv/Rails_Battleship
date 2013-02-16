class EventController < WebsocketRails::BaseController
  include SessionsHelper

  observe do
    puts "new_event was called"
    :signed_in_user
  end

  def initialize_session
    # perform application setup here
    @message_count = 0
    puts '111111111111111111111111'
  end

  def client_connected
    trigger_success message: 'awesome level is sufficient'
    puts "========client_connected==============="

  end

  def new_message
    puts "==============="
    user = User.new
    user.save
    new_message = {:message => 'this is a message'}
    send_message :new_message, new_message
    broadcast_message :new_message, {:message => 'broadcast a message'}
  end

  def rooms_channel
    puts "==============="
    broadcast_message :new_message, {:message => 'this is rooms_channel'}

  end

  def join_room
    puts "=========join_room========"
    room_id = message[:room_id]
    current_user = User.find_by_remember_token(session[:remember_token])
    response_message = "#{current_user.name} has joined the room."
    broadcast_message :join_room, message: response_message
  end

  def leave_room
    puts "=========leave_room========"
    room_id = message[:room_id]
    current_user = User.find_by_remember_token(session[:remember_token])
    response_message = "#{current_user.name} has left the room."
    broadcast_message :join_room, message: response_message
  end

  def fire
    # message is the argument
    # Find user first

    puts "=========fire=============="
    puts message
    puts session
    @room_id = message[:room_id]
    @target_id = message[:target_id]
    @target_user = User.find(@target_id)
    @current_user = User.find_by_remember_token(session[:remember_token])
    puts @current_user
    puts "--------------------"
    #send_message :fire, {:message => 'Fired user'+''}
    respond_message = "User #{@current_user.name} fired [#{message[:x]}, #{message[:y]}] on #{@target_user.name}"
    broadcast_message :fire, {:message => respond_message}
  end

  private
    def signed_in_user
      if signed_in?
        send_message :message ,  'authorization failed!'
      end
    end

end