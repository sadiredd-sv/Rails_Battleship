Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.GameplayView extends Backbone.View
  template: JST["backbone/templates/gameplays/gameplay"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
