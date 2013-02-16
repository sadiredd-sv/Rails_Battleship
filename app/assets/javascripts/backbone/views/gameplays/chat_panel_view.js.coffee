Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.ChatPanelView extends Backbone.View
  template: JST["backbone/templates/gameplays/chatpanel"]

  events: {
    "click .submit-message": "submitMessage"
    "keypress input[type=text]": "pressSubmitMessage"

  },

  initialize: () ->
    @options.chats.bind('reset', @addAll, @)
    @options.chats.bind('add', @addOne, @);

  addAll: () =>
    @options.chats.each(@addOne)

  addOne: (chat) =>
    view = new Battleship.Views.Gameplays.ChatView({model : chat})
#    @$el.append(view.render().el)
    @$("#chat-list-el").append(view.render().el)

  render: =>
    $(@el).html(@template(chats: @options.chats.toJSON() ))
    @addAll()
    return this

  # Create a chat model and save back to the server
  submitMessage: =>
    if $("#broadcastMessage").val() is ""
      return
    console.log(@options.room_id)
    @options.room_id
    chat_atttrs = {
      current_user: @options.current_user
      message: $("#broadcastMessage").val()
      channel: null,
      receiver_id: @options.room_id,
      room_id: @options.room_id, # Refer to the room that is current shown
    }
    chat = new Battleship.Models.Chat(chat_atttrs)
    @options.chats.create(chat.toJSON(),
      success: (chats) =>
        console.log("Created a chat")
#        console.log(chats.collection)

      error: (room, jqXHR) =>
        console.log("Cannot send a message to server.")
    )
    $("#broadcastMessage").val('')

#    @options.channel.trigger('broadcast_chat', message );
#    $("#broadcastMessage").val("")

  pressSubmitMessage: (e) ->
    if (e.keyCode is 13)
      e.preventDefault()
      e.stopPropagation()
      this.submitMessage()

