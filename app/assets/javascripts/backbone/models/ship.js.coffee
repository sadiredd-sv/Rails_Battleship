class Battleship.Models.Ship extends Backbone.Model
  paramRoot: 'ship'

  defaults:
    ship_array: null

  validate: (attrs) ->
    if attrs.ship_array is null
      return 'ship_array must not be null.'

    if attrs.ship_array.length != 17
      return 'ship_size must be 17.'

class Battleship.Collections.ShipsCollection extends Backbone.Collection
  model: Battleship.Models.Ship
  initialize: (props) ->
    @customURL = props.customURL
  url: ()->
    return @customURL
