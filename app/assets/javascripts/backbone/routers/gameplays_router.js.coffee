class Battleship.Routers.GameplaysRouter extends Backbone.Router
  initialize: (options) ->
    @room_id = options.room_id

    @gameplays = new Battleship.Collections.GameplaysCollection()
    # chasr is used by websocket to communicate among users and to trigger some events reflecting game play
    @chats = new Battleship.Collections.ChatsCollection()
    # users is used to show the list of enemies at the buttom right corner
    @users = new Battleship.Collections.UsersCollection({customURL: "/rooms/"+ @room_id + "/list_users"})
    # grids is used to show own status at the buttom left corner
    @grids = new Battleship.Collections.GridsCollection({customURL: "/rooms/"+ @room_id + "/ship_list"})
    # ships is used for deployment only
    @ships = new Battleship.Collections.ShipsCollection({customURL: "/rooms/"+ @room_id + "/deploy_ships"})

    @channel = null
    @current_user = options.current_user
    @user_status = options.user_status
    @users.fetch()
    @grids.reset()
    @grids.fetch()

    # Create necessary attributes
    @createWebsocketChannels()
    @createSubViews()
    @renderSubViews()


  routes:
    "new"      : "newGameplay"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newGameplay: ->
    @view = new Battleship.Views.Gameplays.NewView(collection: @gameplays)
    $("#gameplays").html(@view.render().el)

  index: ->
    @view = new Battleship.Views.Gameplays.IndexView(gameplays: @gameplays)
    $("#gameplays").html(@view.render().el)

  show: (id) ->
    gameplay = @gameplays.get(id)

    @view = new Battleship.Views.Gameplays.ShowView(model: gameplay)
    $("#gameplays").html(@view.render().el)

  edit: (id) ->
    gameplay = @gameplays.get(id)

    @view = new Battleship.Views.Gameplays.EditView(model: gameplay)
    $("#gameplays").html(@view.render().el)

  # Create websocket connection
  createWebsocketChannels: ->
    # Check if the dispatcher is valid or not
    if (window.Battleship.dispatcher is null or window.Battleship.dispatcher.pong() is false)
      window.Battleship.dispatcher = new WebSocketRails('localhost:3000/websocket')
      console.log('Initialize websocket...')

    if (window.Battleship.channels[@room_id] is null) or (typeof window.Battleship.channels[@room_id] is "undefined")
      window.Battleship.channels[@room_id] = window.Battleship.dispatcher.subscribe(@room_id)
      console.log('Binding channel...')

    @channel =  window.Battleship.channels[@room_id]

    # Create chats and set it in the global variable so that it will become visible to channel.bind
    window.Battleship.chats[@room_id] = @chats
    window.Battleship.room_id = @room_id

    # Bind websocket events to the channel
    @channel.bind('user_status', (data)->
      console.log('user_status...')
      console.log(data.message)
    )

    @channel.bind('game_fire', (data)->
      console.log('game_fire')
      console.log(data.message)
    )

    @channel.bind('broadcast_chat', (data)->
      console.log('receiving a new message...')
      window.Battleship.chats[window.Battleship.room_id].add(new Battleship.Models.Chat(data))
    )

  createSubViews: ()->
    # Also attach @channel so that subview knows the instance of channel
    @chatPanelView =  new Battleship.Views.Gameplays.ChatPanelView({chats: @chats, channel: @channel, current_user: @current_user, room_id: @room_id})
    @chatUserListPanelView =  new Battleship.Views.Gameplays.UserListPanelView({users: @users, channel: @channel, current_user: @current_user, room_id: @room_id})
    @gridListPanelView =  new Battleship.Views.Gameplays.GridListPanelView({grids: @grids, channel: @channel, current_user: @current_user, room_id: @room_id})

    # If the user already deploly, skip deploying
    console.log(@user_status)
    if @user_status is "ready"
      @DeployPanelView = new Battleship.Views.Gameplays.DeployPanelView({ships: @ships, grids: @grids, channel: @channel, current_user: @current_user, room_id: @room_id})

  renderSubViews: ()->
    $("#ChatPanelView").html(@chatPanelView.render().el)
    $("#UserListPanelView").html(@chatUserListPanelView.render().el)
    $("#GridListPanelView").html(@gridListPanelView.render().el)
    @gridListPanelView.initializeCanvas()

    if @user_status is "ready"
      $("#DeployPanelView").html(@DeployPanelView.render().el)
      @DeployPanelView.initializeCanvas()

