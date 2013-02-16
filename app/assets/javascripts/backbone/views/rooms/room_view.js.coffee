Battleship.Views.Rooms ||= {}

class Battleship.Views.Rooms.RoomView extends Backbone.View
  template: JST["backbone/templates/rooms/room"]

  initialize: () ->
    @current_user =  @options.current_user
    @model.bind('change', @render, @) # When binding, always attach @ as context


  events:
    "click .destroy" : "destroy"

#  tagName: "div"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    modelAttrs =  @model.attributes
#    console.log(modelAttrs)
    modelAttrs['isJoin'] = @model.isJoin(@current_user)
    $(@el).html(@template(modelAttrs ))
    return this
