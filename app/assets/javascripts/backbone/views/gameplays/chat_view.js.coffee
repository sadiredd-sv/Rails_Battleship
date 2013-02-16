Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.ChatView extends Backbone.View
  template: JST["backbone/templates/gameplays/chat"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
