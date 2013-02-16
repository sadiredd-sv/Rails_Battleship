Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.StatusView extends Backbone.View
  template: JST["backbone/templates/gameplays/status"]

  initialize: () ->
    @model.bind('change', @render, @) # When binding, always attach @ as context

  events: {
#  "click .target-user": "getUserGrid"
  #  "keypress input[type=text]": "pressSubmitMessage"

  },

  render: ->
    @model.setCurrentPlayerName()
    console.log(@model)
    $(@el).html(@template(@model.toJSON() ))
    return this


