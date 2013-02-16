Battleship.Views.Rooms ||= {}

class Battleship.Views.Rooms.IndexView extends Backbone.View
  template: JST["backbone/templates/rooms/index"]

  events:
    "click .room-refresh": "refresh"


  initialize: () ->
    @options.rooms.bind('reset', @addAll)
#    @options.rooms.bind('add', @addOne, @)

  addAll: () =>
    @$("#rooms-table").html("")
    @options.rooms.each(@addOne)

  addOne: (room) =>
    view = new Battleship.Views.Rooms.RoomView({model : room, current_user: @options.current_user })
    @$("#rooms-table").append(view.render().el)

  render: =>
    $(@el).html(@template(rooms: @options.rooms.toJSON() ))
    @addAll()

    return this


  refresh: ()=>
    console.log('asdfsadf')
#    @options.rooms.reset(
#      success: (rooms) =>
#        console.log('fffff')
#    )