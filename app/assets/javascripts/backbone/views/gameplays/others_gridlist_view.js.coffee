Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.OthersGridListView extends Backbone.View
  template: JST["backbone/templates/gameplays/others_gridlist"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
