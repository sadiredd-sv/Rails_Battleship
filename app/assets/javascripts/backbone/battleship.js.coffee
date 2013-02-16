#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Battleship =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  dispatcher: null # Main dispatcher used in websocket
  channels: {} # Create change to be used in websocket
  chats: {} # Collections of chats
  grids: null  # Collection of grids
  current_room_id: null