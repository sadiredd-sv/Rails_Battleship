Battleship.Views.Rooms ||= {}

class Battleship.Views.Rooms.ShowView extends Backbone.View
  template: JST["backbone/templates/rooms/show"]

  initialize: () ->
    @model.bind('change', @render, @) # When binding, always attach @ as context
    @model.bind('all', @test, @) # When binding, always attach @ as context

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this

  test: ()->
#    console.log('asdfasdfasfsdafasdf')