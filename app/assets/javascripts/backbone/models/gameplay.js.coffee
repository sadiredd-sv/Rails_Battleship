class Battleship.Models.Gameplay extends Backbone.Model
  paramRoot: 'gameplay'

  defaults:
    room_id: null

class Battleship.Collections.GameplaysCollection extends Backbone.Collection
  model: Battleship.Models.Gameplay
  url: '/gameplays'
