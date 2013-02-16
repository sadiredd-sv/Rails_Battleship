class Battleship.Models.Salvo extends Backbone.Model
  paramRoot: 'salvo'

  defaults:
    targets: null

  initialize: (props) ->
    @customURL = props.customURL
  url: ()->
    return @customURL