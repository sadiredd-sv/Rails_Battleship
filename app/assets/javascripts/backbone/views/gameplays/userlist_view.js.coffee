Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.UserListView extends Backbone.View
  template: JST["backbone/templates/gameplays/userlist"]

  initialize: () ->
    @model.bind('reset', @render, @) # When binding, always attach @ as context
#    @options.room.bind('change', @getUserGrid, @)

  events: {
    "click .target-user": "getUserGrid"
  #  "keypress input[type=text]": "pressSubmitMessage"

  },

  render: ->
    console.log('room change -> render')
    $(@el).html(@template(@model.toJSON()))
#    @getUserGrid()
    return this

  getUserGrid: ()->

    console.log($(@el).find(".active").data('target'))

#      j = $(".active")
#      target_id = j.data('target')
    target_id = $(@el).find(".active").data('target')
    console.log(target_id)
    @options.grids.trigger('renderview', target_id)



