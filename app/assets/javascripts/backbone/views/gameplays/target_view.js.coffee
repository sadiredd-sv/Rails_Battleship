Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.TargetView extends Backbone.View
  template: JST["backbone/templates/gameplays/target"]

  initialize: () ->
    @model.bind('change', @render, @) # When binding, always attach @ as context

  events: {
#  "click .target-user": "getUserGrid"
  #  "keypress input[type=text]": "pressSubmitMessage"

  },

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this