Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.UserListPanelView extends Backbone.View
  template: JST["backbone/templates/gameplays/userlistpanel"]

  events: {
#  "click .submit-message": "submitMessage"
#  "keypress input[type=text]": "pressSubmitMessage"

  },

  initialize: () ->
    @options.room.bind('reset', @addAll, @)
    @options.room.bind('gameplay', @roomChanged, @)

  addAll: () =>
    @addOne(@options.room)

  addOne: (model) =>
    view = new Battleship.Views.Gameplays.UserListView({model : model, room: @options.room, targets: @options.targets })
    @$el.append(view.render().el)

  render: =>
    $(@el).html(@template(@options.room.toJSON() ))
    @addAll()
    return this

  roomChanged: ()=>
    console.log('gameplay.....')
#    console.log(@options)
#    view = new Battleship.Views.Gameplays.UserListView({model : @options.room, room: @options.room, targets: @options.targets })
#    @$el.append(view.render().el)