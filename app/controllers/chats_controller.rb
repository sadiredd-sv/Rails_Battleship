class ChatsController < ApplicationController
  include SessionsHelper
  before_filter :signed_in_user

  CHAT_EVENT_NAME =  :chat_event

  # POST /rooms
  # POST /rooms.json
  def create
    room_id = params[:chat][:room_id]
    @chat = current_user.chats.build({message: params[:chat][:message],
                                      room_id: params[:chat][:room_id],
                                      receiver_id: params[:chat][:receiver_id]})

    if @chat.isSendToRoom?
      if current_user.rooms.find(room_id)
        response = "ok"

      else
        response = 'You have not join the room' + room_id
      end
    elsif @chat.isSendToPerson?
      response = 'Send to ' + @chat.to_user_id
    else # Broadcast to all users
      response = "ok"
    end

    chat_attrs = @chat.attributes
    chat_attrs['current_user'] = current_user
    chat_attrs['response'] = response
    if params[:chat][:room_id] == nil
      channel = "server_channel"
    else
      channel = room_id
    end

    self.broadcast_message_to_channel(channel, CHAT_EVENT_NAME, chat_attrs)
    render json:  chat_attrs.to_json
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
