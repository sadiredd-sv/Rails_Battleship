Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.GridListView extends Backbone.View
  template: JST["backbone/templates/gameplays/gridlist"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
