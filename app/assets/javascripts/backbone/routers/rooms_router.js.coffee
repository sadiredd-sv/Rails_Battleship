class Battleship.Routers.RoomsRouter extends Backbone.Router
  initialize: (options) ->
    @rooms = new Battleship.Collections.RoomsCollection()

    # chats is used by websocket to communicate among users and to trigger some events reflecting game play
    @chats = new Battleship.Collections.ChatsCollection()

    # Call reset to build a new list of rooms
    @rooms.reset null
#    @rooms.fetch()
    @current_user = options.current_user

    # Initialize the jQuery element
    @row_0_el = $("#row0")
    @row_1_el = $("#row1")
    @row_2_el = $("#row2")
    @deploy_el = $("#deploy")
    @others_el = $("#others")
    @chat_el = $("#chat")
    @chat_panel_view_el = $("#ChatPanelView")
    @room_chat_panel_view_el = $("#roomChatPanelView")
    @fire_target_el = $("#fireTarget")
    @players_el = $("#players")
    @ship_el = $("#ship")
    @status_el = $("#status")

  # Show mechanism
  showRow0: ()->
    @row_0_el.removeClass('hide')
    @row_1_el.addClass('hide')
    @row_2_el.addClass('hide')

  hideRow0: ()->
    @row_0_el.addClass('hide')
    @row_1_el.removeClass('hide')
    @row_2_el.removeClass('hide')

  routes:
    "new"      : "newRoom"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ":id/join" : "join"
    ":id/leave" : "leave"
    ":id/ready" : "ready"
    ":id/play" : "play"
    ".*"        : "index"

  newRoom: ->
    @showRow0()
    @view = new Battleship.Views.Rooms.NewView(collection: @rooms)
    $("#rooms").html(@view.render().el)

  index: ->
    @showRow0()
    @createServerChannels()
    @createRoomChatViews(null)
    @rooms.fetch(success: (rooms) =>
      @view = new Battleship.Views.Rooms.IndexView({rooms: @rooms, current_user: @current_user})
      $("#rooms").html(@view.render().el)
    )
    @chatPanelView =  new Battleship.Views.Gameplays.ChatPanelView({chats: @chats, current_user: @current_user})
    @chat_panel_view_el.html(@chatPanelView.render().el)

  show: (id) ->
    @initWebSocket(id)
    @showRow0()
    @createRoomChatViews(id)
    if @rooms is null or @rooms.length is 0
      @rooms.fetch(success: (rooms) =>
        room = rooms.get(id)
        @showDetails(room, id)
      )
    else
      room = @rooms.get(id)
      @showDetails(room, id)

  showDetails: (room, id) ->
    @initWebSocket(id)
    window.Battleship.current_room_id = id # Set room_id so that chat can grap the value
    @view = new Battleship.Views.Rooms.ShowView(model: room)
    $("#rooms").html(@view.render().el)


  edit: (id) ->
    @initWebSocket(id)
    room = @rooms.get(id)
    @view = new Battleship.Views.Rooms.EditView(model: room)
    $("#rooms").html(@view.render().el)

  join: (id) ->
    room = @rooms.get(id)

    # Attach callack so that it is known that update is successful.
    room.join(id, (data)=> # success
      @initWebSocket(id)
      room.set(data)
      window.Battleship.current_room_id = id # Set room_id so that chat can grap the value
      window.location.hash = "/"+id
    , ()=> #fail
      alert('cannot join the room. The room might be full or locked!')
      window.location.hash = "index"
    )

  leave: (id) ->
    @initWebSocket(id)
    console.log("id="+id)
    room = @rooms.get(id)
    # Attach callack so that it is known that update is successful.
    room.leave(id, (data)=>
      room.set(data)
      window.Battleship.current_room_id = null # Clear the current room_id
      # Redirect to #index
      window.location.hash = "index"
#      @filterChatPanelView(id)
    )

  ready: (id) ->
    @initWebSocket(id)
    # Change the status of the user to be 'ready'
    room = @rooms.get(id)
    room.ready(id, (data)=>
      room.set(data)
      window.location.hash = "/"+id
    )

  play: (id) ->
    @hideRow0()
    @createRoomChatViews(id)
    @initWebSocket(id)
    # Create subviews
    room = @rooms.get(id)
    if @rooms is null or @rooms.length is 0
      @rooms.fetch(success: (rooms) =>
        room = rooms.get(id)
        @cratePlayView(room)
      )
    else
      room = @rooms.get(id)
      @cratePlayView(room)

  initWebSocket: (room_id)->
    @createServerChannels()
    @createWebsocketChannels(room_id)

  createRoomChatViews: (id)->
      # Also attach @channel so that subview knows the instance of channel
    @chats = new Battleship.Collections.ChatsCollection()
    @chatPanelView =  new Battleship.Views.Gameplays.ChatPanelView({chats: @chats, current_user: @current_user, room_id: id})
    @chat_panel_view_el.html(@chatPanelView.render().el)
    console.log('create room chat...')
    console.log({chats: @chats, current_user: @current_user, room_id: id})

  cratePlayView: (room)->
    room_id = room.get('id')
    window.Battleship.current_room_id

    grids = new Battleship.Collections.GridsCollection({customURL: "/rooms/"+ room_id + "/grid_list"})
    # ships is used for deployment only
    ships = new Battleship.Collections.ShipsCollection({customURL: "/rooms/"+ room_id + "/deploy_ships"})

    grids.reset()
    grids.fetch()

    # Own grids
    gridListPanelView =  new Battleship.Views.Gameplays.GridListPanelView({grids: grids, current_user: @current_user, room_id: room_id})
    $("#GridListPanelView").html(gridListPanelView.render().el)
    gridListPanelView.initializeCanvas()

    if room.isReady()
      DeployPanelView = new Battleship.Views.Gameplays.DeployPanelView({ships: ships, grids: grids, current_user: @current_user, room_id: room_id})
      $("#DeployPanelView").html(DeployPanelView.render().el)
      DeployPanelView.initializeCanvas()
      DeployPanelView.initializeTimer()


    # User list
    targets = new Battleship.Collections.TargetsCollection({customURL: "/rooms/"+ room_id + "/fire"})
    targets.reset null
    users = new Battleship.Collections.UsersCollection({customURL: "/rooms/"+ room_id + "/list_users"})
    users.fetch()
    UserListPanelView =  new Battleship.Views.Gameplays.UserListPanelView({room: room, current_user: @current_user, room_id: room_id, targets: targets, grids: grids})
    $("#UserListPanelView").html(UserListPanelView.render().el)

    # Status
    statusView = new  Battleship.Views.Gameplays.StatusPanelView({room: room, current_user: @current_user, room_id: room_id})
    $("#StatusView").html(statusView.render().el)

    # Other grids
    target_id = room.getFirstTarget()
    if (target_id isnt null)
      grids = new Battleship.Collections.GridsCollection({customURL: "/rooms/"+ room_id + "/user/" + target_id.id })
      grids.reset()
      grids.fetch()
    else
      grids = null
    # Maintain the grid target globally to allow salvo play
    othersGridListPanelView =  new Battleship.Views.Gameplays.OthersGridListPanelView({grids: grids, targets: targets, room: room})
    $("#OthersGridView").html(othersGridListPanelView.render().el)
    othersGridListPanelView.initializeCanvas()

    # Target and Fire
    targetPanelView = new  Battleship.Views.Gameplays.TargetPanelView({room: room, targets: targets, grids: grids})
    $("#TargetView").html(targetPanelView.render().el)
    targetPanelView.initializeTimer()


  # Create websocket connection
  createWebsocketChannels: (room_id)->
    # Check if the dispatcher is valid or not
    if (window.Battleship.dispatcher is null or window.Battleship.dispatcher.pong() is false)
      url = window.location.host
      window.Battleship.dispatcher = new WebSocketRails(url+ '/websocket')
      console.log('Initialize websocket...')

    channel = null

    if (window.Battleship.channels[room_id] is null) or (typeof window.Battleship.channels[room_id] is "undefined")
      window.Battleship.channels[room_id] = window.Battleship.dispatcher.subscribe(room_id)
      console.log('Binding channel...'+room_id)

      channel =  window.Battleship.channels[room_id]

      # Create chats and set it in the global variable so that it will become visible to channel.bind
      window.Battleship.chats[room_id] = @chats
      window.Battleship.room_id = room_id

      channel.bind('user_status', (data)=>
        console.log('user_status...')
        console.log(data)
        # Crate a chat message
        chat = new Battleship.Models.Chat(data)
        @chats.add(chat)
        room = @rooms.get(data.room_id)
        room.fetch success: (data)=>
          console.log('fetch room for status successfully')
          console.log(data)
          @showDetails(data, data.room_id)
      )

      channel.bind('game_fire', (data)=>
        console.log('game_fire')
        console.log(data.message)
      )

      channel.bind('chat_event', (data)=>
        console.log('receiving a new message...')
        console.log(data)
        if (data.user_id isnt @current_user.id)
          chat = new Battleship.Models.Chat(data)
          @chats.add(chat)
      )

      channel.bind('game_play', (data)=>
        console.log('++++game play+++++')
        chat = new Battleship.Models.Chat(data)
        @chats.add(chat)
        room = @rooms.get(data.room_id)
        room.fetch(success: (data)=>
          console.log('fetch room for game play successfully')
          data.trigger('gameplay')
        )
      )

      channel.bind('change_turn', (data)=>
        console.log('++++change turn+++++')
        chat = new Battleship.Models.Chat(data)
        @chats.add(chat)
        room = @rooms.get(data.room_id)
        room.fetch(success: ()=>
          console.log('fetch room successfully')
          @cratePlayView(room)
        )
      )

      channel.bind('game_end', (data)=>
        console.log('++++change turn+++++')
        chat = new Battleship.Models.Chat(data)
        @chats.add(chat)
        room = @rooms.get(data.room_id)
        room.fetch(success: ()=>
          console.log('Game Ended')
          alert("WINNER IS "+ room.winner)
        )
      )

      #this event starts timer if atleast 2 people in the room are ready
      channel.bind('start_timer', (data)=>
        console.log('start_timer...')
        console.log(data.message)
        room = @rooms.get(data.room_id)
        room.fetch(success: ()=>
          console.log('fetch room successfully')
          $('#timer_counter').pietimer({
            seconds: 5,
            color: 'rgba(0,0,0,0.8)',
            height: 100,
            width: 100
          },
          () ->
            urlString="/rooms/#/" + data.room_id + "/play"
            window.location=urlString
          )
          $('#timer_counter').pietimer('start')
          # Add a message
          chat = new Battleship.Models.Chat(data)
          @chats.add(chat)
        )
      )

    window.Battleship.channels[room_id]

  # Create websocket connection
  createServerChannels: ()->
    # Check if the dispatcher is valid or not
    if (window.Battleship.dispatcher is null or window.Battleship.dispatcher.pong() is false)
      url = window.location.host
      window.Battleship.dispatcher = new WebSocketRails(url+ '/websocket')
      console.log('Initialize websocket...')

    server = "server_channel"
    #
    if (window.Battleship.channels[server] is null) or (typeof window.Battleship.channels[server] is "undefined")
      window.Battleship.channels[server] = window.Battleship.dispatcher.subscribe(server)
      console.log('Binding server channel...')
      channel =  window.Battleship.channels[server]

      # Bind websocket events to the channel
      channel.bind 'room_created', (data)=>
        # Refetch all the rooms
        console.log('room_created...')
        @rooms.fetch(success: (data)=>
          console.log('Fetch room soccessfully')
          console.log(data)
        )

      channel.bind 'chat_event', (data)=>
        console.log('receiving a new broadcast message...')
        console.log(data)
        if (data.current_user.id isnt @current_user.id)
          chat = new Battleship.Models.Chat(data)
          @chats.add(chat)

  deleteWebsocketChannels: (room_id)->
#    window.Battleship.channels[room_id] = null
