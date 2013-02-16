Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.DeployView extends Backbone.View
  template: JST["backbone/templates/gameplays/deploy"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
