Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.GridListPanelView extends Backbone.View
  template: JST["backbone/templates/gameplays/gridlistpanel"]

  events: {
  #  "click .submit-message": "submitMessage"
  #  "keypress input[type=text]": "pressSubmitMessage"

  }

  initialize: () ->
    @options.grids.bind('reset', @addAll)
    @options.grids.bind('add', @addOne);

#    @layerGrid = new Kinetic.Layer()
    @layerShip = new Kinetic.Layer()
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
    @_dimension = 18
    _numberOfGrids = 10
    _timeoutPeridMS = 60000 # 1 minutes
    @stage = new Kinetic.Stage({
      container: 'ownGridCanvas',
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
#    @stage.add(@layerGrid)
    @stage.add(@layerShip)

  markTargets: (coordinate_list)->
    # Create another layer to mark target

    @stage.add(@layerFiring)

  addAll: () =>
    @options.grids.each(@addOne)

  addOne: (grid) =>
    if grid.isValid()
      view = new Battleship.Views.Gameplays.GridListView({model : grid})
      @$el.append(view.render().el)

      # Asynchronously draw the ship and draw the layer
#      if (grid.isHeader())
      ship = grid.createShipElement(@_dimension)
      @layerShip.add(ship)
      @layerShip.draw()


  render: =>
    console.log('Create grid canvas')
    $(@el).html(@template(grids: @options.grids.toJSON() ))
    @addAll()
    return this
