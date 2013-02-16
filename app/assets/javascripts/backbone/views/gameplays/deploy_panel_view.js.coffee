Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.DeployPanelView extends Backbone.View
  template: JST["backbone/templates/gameplays/deploypanel"]

  events: {
    "click #deployShip": "deployShip"
    'click #randomShip': "initializeCanvas"
  }

  initialize: () ->
    console.log(@options)
#    @options.grids.bind('reset', @addAll)
#    @options.grids.bind('add', @addOne);

    @layerGrid = new Kinetic.Layer()
    @layerShip = new Kinetic.Layer()
    @isDeployed = false

  addAll: () =>
    @options.ships.each(@addOne)

  addOne: (grid) =>
    if grid.isValid()
      view = new Battleship.Views.Gameplays.DeployView({model : grid})
      @$el.append(view.render().el)
#      console.log(grid.attributes)
      ship = @createShipElement(grid.get('id'),
      grid.get('coordinate_x'),
      grid.get('coordinate_y'),
      @_dimension,
      grid.get('ship_size'),
      grid.get('alignment')
      )
#      console.log(ship)
      @layerShip.add(ship)

  render: =>
#    console.log(@options.ships.toJSON())
    $(@el).html(@template(grids: @options.ships.toJSON() ))
    @addAll()
    return this

  deployShip: (e) =>
   # if e isnt null or typeof(e) isnt 'undefined'
   #   e.preventDefault()
   #   e.stopPropagation()

    ship_data_array = []
    for ship in @layerShip.getChildren()
      for element in ship.getAttrs().toJSON()
        ship_data_array.push(element)

    # Save ship into a backbone model
    ship = new @options.ships.model({ship_array: ship_data_array})
    ship.unset("errors")
    @options.ships.create(ship.toJSON(),
      success: (data) =>
        # Trigger grid model to fetch from the server
        @options.grids.fetch()
        # Remove deploy view
        $("#deploy").remove()
        $("#others").removeClass('span4')
        $("#others").addClass('span8')
        @isDeployed = true
      error: (data, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  initializeTimer: ()->
    $('#deploy_counter').pietimer({
      seconds: 60,
      color: 'rgba(0,0,0,0.8)',
      height: 100,
      width: 100
    },
    () =>
      if (@isDeployed isnt true)
        @deployShip()
    )
    $('#deploy_counter').pietimer('start')


  initializeCanvas: ()->
    @_dimension = 30
    _numberOfGrids = 10
    _timeoutPeridMS = 60000 # 1 minutes
    @stage = new Kinetic.Stage({
    container: 'shipDeploymentCanvas',
    width: @_dimension * _numberOfGrids,
    height: @_dimension * _numberOfGrids
    })

    gameGridb = {}
    for i in [0..9]
      for j in [0..9]
        # Create a instance of grids

        rect = @createGridElement(i*30, j*30 ,30)
        gameGridb["#{i},#{j}"] = rect

        # add the shape to the layer
        @layerGrid.add(rect)

    ship_list = window.getCoord()
    for s in [0..4]
      ship =  @createShipElement(ship_list[s][0]+1, ship_list[s][3], ship_list[s][4] , @_dimension, ship_list[s][2], ship_list[s][1])
      @layerShip.add(ship)
#    ship1 = @createShipElement(1,0,0, @_dimension, 2, 'v')
#    ship2 = @createShipElement(2,0,3, @_dimension, 3, 'h')
#    ship3 = @createShipElement(3,5,2, @_dimension, 3, 'v')
#    ship4 = @createShipElement(4,1,7, @_dimension, 4, 'h')
#    ship5 = @createShipElement(5,5,9, @_dimension, 5, 'h')
#    @layerShip.add(ship1)
#    @layerShip.add(ship2)
#    @layerShip.add(ship3)
#    @layerShip.add(ship4)
#    @layerShip.add(ship5)

    # add the layers to the stage
    @stage.add(@layerGrid)
    @stage.add(@layerShip)

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


  createShipElement: (id, x,y, dimension, size, alignment='v', gridNumber = 10) ->
    ### Default values ###
    shipWidth = shipHeigth = dimension

    ### Find if either shipWidth or shipHeight will be changed. ###
    if alignment is 'v' then shipHeigth *= size else shipWidth *= size

    ### Create and return a rectangular instance ###

    imageObj = new Image()
    console.log(size)
    if size is 2
      imageObj.src = 'http://icons.iconarchive.com/icons/everaldo/crystal-clear/128/App-battleship-boat-icon.png'
    else if size is 3
      imageObj.src ='http://www.spore.com/static/thumb/500/055/766/500055766932.png'
                    # 'http://godsofart.com/wp-content/uploads/2012/04/zodanga-battleship-01-by-ryan-church.jpg'
    else if size is 4
      imageObj.src ='http://www.scalehobbyist.com/images/catagorypics/battleship_4.jpg'
    else
      imageObj.src ='http://godsofart.com/wp-content/uploads/2012/04/zodanga-battleship-01-by-ryan-church.jpg'

      #http://godsofart.com/wp-content/uploads/2012/04/zodanga-battleship-01-by-ryan-church.jpg


    rect = new Kinetic.Image({

#      #x: 140,
#      #y: stage.getHeight() / 2 - 59,
#      x:90,
#      y: 30,
#      image: imageObj,
#      width: 60,
#      height: 118
#    })
      image: imageObj,
      x: x * dimension,
      y: y * dimension,
      width: shipWidth,
      height: shipHeigth,
      fill: 'yellow',
      stroke: 'black',
      strokeWidth: 0.5,
      draggable: true,
      name: "ship"
      id: id,
      shipSize: size,
      shipAlignment: alignment,
      shipDimension: dimension,
      currentCoordinateX: x,
      currentCoordinateY: y,
      previousCoordinateX: 0,
      previousCoordinateY: 0,
      getShipCoordinates: ()->
        ###
        Caculate the coordinates of the ship by increasing from the main
        coordinate either vertically or horizontally.
        ###
        self = this
        sSize = self.shipSize
        sAlignment = self.shipAlignment
        sX = self.currentCoordinateX
        sY = self.currentCoordinateY
        sCooridinates = []
        if sAlignment is 'v'
          for i in [0..sSize-1]
            sCooridinates.push({x: sX, y: sY+i})
        else
          for i in [0..sSize-1]
            sCooridinates.push({x: sX+i, y: sY})

        sCooridinates
      ,
      isShipOverlapped: (self) ->
        allShips = self.getParent().get(".ship")
        isOverlap = false
        selfAttrs = self.getAttrs()
        selfCoords = self.getAttrs().getShipCoordinates()
        for ship in allShips when ship.getAttrs().id isnt selfAttrs.id
          attrs = ship.getAttrs()
          for selfCoord in selfCoords
            for anotherCoord in attrs.getShipCoordinates()
              # console.log("Finding overlapping ares #{attrs.id}=[#{anotherCoord.x}, #{anotherCoord.y}] look for [#{selfCoord.x}, #{selfCoord.y}]")
              if (anotherCoord.x is selfCoord.x) and (anotherCoord.y is selfCoord.y)
                isOverlap = true
                console.log("Found overlapping areas between #{attrs.id} #{selfAttrs.id}")

        isOverlap
      ,
      isOutofBoundary: (self) ->
        pos = self.getPosition()
        boundaryX = false
        if pos.x < 0
          # lower boundary
          boundaryX = true
        else if pos.x+self.getAttrs().width > dimension*gridNumber
          # upper boundary
          boundaryX = true
        else
          boundaryX = false

        if pos.y < 0
          # lower boundary
          boundaryY = true
        else if pos.y+self.getAttrs().height > dimension*gridNumber
          # upper boundary
          boundaryY = boundaryY = true
        else
          boundaryY = false

        # Return
        boundaryX or boundaryY
      ,
      rotateShip: (self, callback) ->
        ###
        This will rotate the ship by maintain the main coordinate. For example, the ship's main coordinate is {2,2} and the size
        of the ship is 3 and its alignment is 'v'. This means that the shipCooridnate is [ {2,2} , {2,3}, {2,4}]. The
        rotation will maintain {2,2} as the main coordinate and swap the width and the height.
        ###

        # Start trasforming the ship
        newAlignment = if this.shipAlignment is 'v' then 'h' else 'v'

        self.setAttrs({shipAlignment: newAlignment, height: this.width, width: this.height})
        # Reverse back if the ship rotated is overlapped
        if self.getAttrs().isShipOverlapped(self) or self.getAttrs().isOutofBoundary(self)
          console.log("Cannot rotate the ship due to overlapping areas!!")
          newAlignment = if self.getAttrs().shipAlignment is 'v' then 'h' else 'v'
          self.setAttrs({shipAlignment: newAlignment, height: this.width, width: this.height})

        else
          self.transitionTo
            duration: 0.1
            height: this.height
            width: this.width
            callback: callback

      ,
      dragBoundFunc: (pos) ->
        # Limit the boundary to 0 to dimension x gridNumber (10 as default).
        # If pos is exeeed the two number, revert it back to boundary of the gird.
        if pos.x < 0
          # lower boundary
          boundaryX = 0
        else if pos.x+this.getAttrs().width > dimension*gridNumber
          # upper boundary
          boundaryX = dimension* gridNumber - this.getAttrs().width
        else
          boundaryX = pos.x

        if pos.y < 0
          # lower boundary
          boundaryY = 0
        else if pos.y+this.getAttrs().height > dimension*gridNumber
          # upper boundary
          boundaryY =  dimension*gridNumber - this.getAttrs().height
        else
          boundaryY = pos.y

        # console.log("BOUNDARY=[#{boundaryX}, #{boundaryY}]")
        {
        x: boundaryX,
        y: boundaryY
        }
      ,
      toJSON: () ->
        results_array = []
        for cooridnate in this.getShipCoordinates()

          results = {}
          results.coordinate_x = cooridnate.x
          results.coordinate_y = cooridnate.y
          results.alignment = this.shipAlignment
          results.ship_size = this.shipSize
          results.ship_id = this.id
          results.current_coordinate_x = this.currentCoordinateX
          results.current_coordinate_y = this.currentCoordinateY


          results_array.push(results)

        results_array
      })

    ### Add constrains ###
    rect.on 'dragmove', (evt) ->
      newPositionX = this.getPosition().x
      newPositionY = this.getPosition().y
      # Check X
      if (this.getPosition().x % dimension) > dimension/2
        newPositionX = Math.round(this.getPosition().x / dimension) * dimension
      else
        newPositionX = Math.floor(this.getPosition().x / dimension) * dimension
      # Check Y
      if (this.getPosition().y % dimension) > dimension/2
        newPositionY = Math.round(this.getPosition().y / dimension) * dimension
      else
        newPositionY = Math.floor(this.getPosition().y / dimension) * dimension

      # console.log("[#{this.getPosition().x} , #{this.getPosition().y}]   -> [#{newPositionX}, #{newPositionY}]")
      if newPositionX isnt this.getPosition().x or newPositionY isnt this.getPosition().y
        # Assign ship coordinate
        this.getAttrs().currentCoordinateX = newPositionX / this.getAttrs().shipDimension
        this.getAttrs().currentCoordinateY = newPositionY / this.getAttrs().shipDimension

        # Set a new position
        this.setPosition(newPositionX, newPositionY)
    # console.log("[#{newPositionX}, #{newPositionY}], Coor:[#{this.getAttrs().shipX}, #{this.getAttrs().shipY}]")

    ###
    Maintain the previous coordinates so that the ship could be reversed back to
    its own position when overalapping occurs
    ###
    rect.on 'dragstart', (evt) ->
      # Main the previous position before setting a new prosition
      this.setAttrs({ previousCoordinateX: this.getAttrs().currentCoordinateX , previousCoordinateY: this.getAttrs().currentCoordinateY})
    #console.log("Set previous #{this.getAttrs().id} position [#{this.getAttrs().previousCoordinateX}, #{this.getAttrs().previousCoordinateY}]")

    ### If the ship overlaps with another one, revert it to the default state ###
    rect.on 'dragend', (evt) ->
      # Find overlapping areas
      isShipOverlapped = this.getAttrs().isShipOverlapped(this)
      if isShipOverlapped
        # Calculate coordinates back to pixel
        newCoordinateX = this.getAttrs().previousCoordinateX * this.getAttrs().shipDimension
        newCoordinateY = this.getAttrs().previousCoordinateY * this.getAttrs().shipDimension

        # Reset previous position
        this.getAttrs().currentCoordinateX =  this.getAttrs().previousCoordinateX
        this.getAttrs().currentCoordinateY =  this.getAttrs().previousCoordinateY
        # this.setPosition(newCoordinateX, newCoordinateY)

        # Transition to the new position
        this.transitionTo
          duration: 0.2
          x: newCoordinateX
          y: newCoordinateY
          easing: 'linear'

        console.log("Reverse back to [#{newCoordinateX}, #{newCoordinateY}]")

    ### Bind click event to rotate the ship ###
    rect.on 'click', (evt) ->
      #console.log("click..")
      this.getAttrs().rotateShip(this)



    ### Add cursor style ###
    #  rect.on("mouseover", () ->
    #    document.body.style.cursor = "pointer";
    #  )
    #  rect.on("mouseover", () ->
    #    document.body.style.cursor = "default";
    #  )

    ### Return the object ###
    rect


