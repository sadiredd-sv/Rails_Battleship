Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.OthersGridListPanelView extends Backbone.View
  template: JST["backbone/templates/gameplays/others_gridlistpanel"]

  events: {
  #  "click .submit-message": "submitMessage"
  #  "keypress input[type=text]": "pressSubmitMessage"

  }

  initialize: () ->
    @options.grids.bind('reset', @addAll)
    @options.grids.bind('add', @addOne)
    @options.grids.bind('renderview', @addAll)
    @options.count = 5
#    @options.targets

    #    @layerGrid = new Kinetic.Layer()
    @options.layerShip = new Kinetic.Layer()
    @layerFiring = new Kinetic.Layer()

  createGridElement: (x,y, dimension) =>
    rect = new Kinetic.Text({
    x: x,
    y: y,
    width: dimension,
    height: dimension,
    fill: 'blue',
    stroke: 'black',
    strokeWidth: 0.5,

    #  For ext
    #  text: "[#{x/dimension},#{y/dimension}}",
    #  fontSize: 12,
    #  fontFamily: "Calibri",
    #  textFill: "black"
    })

    # return rect
    rect

  initializeCanvas: ()->
    @_dimension = 40
    _numberOfGrids = 10
    _timeoutPeridMS = 60000 # 1 minutes
    @options.stage = new Kinetic.Stage({
    container: 'othersGridCanvas',
    width: @_dimension * _numberOfGrids,
    height: @_dimension * _numberOfGrids
    })

    #    gameGridb = {}
    #    for i in [0..9]
    #      for j in [0..9]
    #        # Create a instance of grids
    #
    #        rect = @createGridElement(i*30, j*30 ,30)
    #        gameGridb["#{i},#{j}"] = rect
    #
    #        # add the shape to the layer
    #        @layerGrid.add(rect)

    # add the layers to the stage
    #    @options.stage.add(@layerGrid)
    @options.stage.add(@options.layerShip)

  markTargets: (coordinate_list)->
    # Create another layer to mark target

    @options.stage.add(@layerFiring)

  addAll: () =>
    @options.grids.each(@addOne)

  addOne: (grid) =>
    if grid.isValid()
      view = new Battleship.Views.Gameplays.OthersGridListView({model : grid})
      @$el.append(view.render().el)
      # Asynchronously draw the ship and draw the layer
      ship = grid.createShipElement(@_dimension, @)
      # Add to layer
      @options.layerShip.add(ship)
      @options.layerShip.draw()


  render: =>
    console.log('Create grid canvas')
    $(@el).html(@template(grids: @options.grids.toJSON() ))
    @addAll()
    return this

  addTarget: (user_id, x, y)->
    canAdd = true;
    _.each @options.targets, (e) =>
      if e.get('user_id') is user_id and e.get('x') is x and e.get('y') is y
        console.log('cannot add duplicate entry')
        canAdd = false

    if canAdd
      @options.targets.add({user_id: user_id, x:x, y:y})

#    console.log(@options.targets)

  removeTarget: (user_id, x, y)->
    removedList = @options.targets.where({user_id: user_id, x:x, y:y})
#    console.log(removedList)
    if removedList.length > 0
      @options.targets.remove(removedList[0])
#    temp = _.reject @options.targets, (e) =>
#      e.user_id is user_id and e.x is x and e.y is y

#    @options.targets.reset()
#    console.log(@options.targets.length)

  getTargetSize: ()->
    @options.targets.length

  getMaxSalvo: ()->
    @options.room.get('salvo')
