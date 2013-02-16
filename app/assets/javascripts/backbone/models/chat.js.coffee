class Battleship.Models.Chat extends Backbone.Model
  paramRoot: 'chat'

  defaults:
    current_user: null
    receiver: null
    message: null
    room_id: null # used to filte out unrelated chanenel


class Battleship.Collections.ChatsCollection extends Backbone.Collection
  model: Battleship.Models.Chat
  url: '/chats'

  listChatsInRoom: (room_id) ->
#    console.log(@)
    @.filter((model) =>
      model.get('room_id') is room_id
    )

  listChatsNotInRoom: () ->
    @.filter((model) =>
      model.get('room_id') is null
    )
