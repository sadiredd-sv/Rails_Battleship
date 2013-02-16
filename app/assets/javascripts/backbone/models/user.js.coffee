class Battleship.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    name: null
    email: null
    status: null
    fire: null
    hit: null
    missed: null
    turn: null

class Battleship.Collections.UsersCollection extends Backbone.Collection
  initialize: (props) ->
    @customURL = props.customURL
  model: Battleship.Models.User
  url: ()->
    return @customURL
