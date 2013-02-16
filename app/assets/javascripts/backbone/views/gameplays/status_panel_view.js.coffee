Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.StatusPanelView extends Backbone.View
  template: JST["backbone/templates/gameplays/statuspanel"]

  events: {
  #  "click .submit-message": "submitMessage"
  #  "keypress input[type=text]": "pressSubmitMessage"

  },

  initialize: () ->
    @options.room.bind('reset', @addAll)

  addAll: () =>
    @addOne(@options.room)

  addOne: (model) =>
    view = new Battleship.Views.Gameplays.StatusView({model : model})
    @$el.append(view.render().el)

  render: =>
    $(@el).html(@template(room: @options.room.toJSON()))
    @addAll()
    return this

#  # Send a message to a room via websecket
#  submitMessage: =>
#    if $("#broadcastMessage").val() is ""
#      return
#    message = {message: $("#broadcastMessage").val(), user: @options.current_user.name}
#    @options.channel.trigger('broadcast_chat', message );
#    $("#broadcastMessage").val("")
#
#  pressSubmitMessage: (e) ->
#    if (e.keyCode is 13)
#      this.submitMessage()

