class Battleship.Models.Room extends Backbone.Model
  paramRoot: 'room'
  urlRoot: '/rooms'
  defaults:
    id: null
    name: null
    max_user: null
    host_id: null
    status: null
    occupancy: null
    users: null  # Array of users in the room
    current_user: null
    current_player: null
    salvo: 1
    current_player_name: null

  # Check if the user is in the room
  isJoin: (user) ->
#    console.log(user)
    id_list = _.pluck(@.get('users'), 'id')
#    console.log(id_list)
    _.contains(id_list, @.get('current_user').id)

  isReady: () ->
    ready = _.filter(@.get('users'), (user)=>
      user.id is @get('current_user').id and user.status is 'ready'
    )
    ready.length > 0

  join: (id, doneCallback, failCallback) ->
    # Call /rooms/id/join
    $.ajax({
      type: "GET",
      dataType: "json",
      url: "/rooms/"+id+"/join"
    }).done( ( data ) ->
      # call callback function
      if doneCallback
        doneCallback(data)
    ).fail( (data) ->
#      alert('Connot join the room')
      if failCallback
        failCallback(data)
    )

  leave: (id, callback) ->
    # Call /rooms/id/join
    $.ajax({
    type: "GET",
    dataType: "json",
    url: "/rooms/"+id+"/leave"
    }).done( ( data ) ->
      # call callback function
      callback(data)
    )

  ready: (id, callback) ->
    # Call /room/id/ready
    $.ajax({
      type: "GET",
      dataType: "json",
      url: "/rooms/"+id+"/ready"
    }).done( ( data ) ->
      # call callback function
      callback(data)
    )

  isTurn: ()->
    @.get('current_user').id is @.get('current_player')

  getFirstTarget: ()->
    ready = _.filter(@.get('users'), (user)=>
      user.id isnt @get('current_user').id
    )
    if ready.length > 0
      ready[0]
    else
      null

  setCurrentPlayerName: ()->
    users = _.filter(@.get('users'), (user)=>
      user.id is @get('current_player')
    )
    if users.length > 0
      tmp = users[0]
      @.set({'current_player_name': tmp.name})


class Battleship.Collections.RoomsCollection extends Backbone.Collection
  model: Battleship.Models.Room
  url: '/rooms'
