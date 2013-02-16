class Battleship.Models.Grid extends Backbone.Model
  paramRoot: 'grid'

  defaults:
    ship_id: null
    status: null
    ship_size: null
    alignment: null
    coordinate_x: null
    coordinate_y: null
    current_coordinate_x: null
    current_coordinate_y: null
    shooter_id: null
    shooter: null
    user_id: null
    is_targeted: false

  validate: (attrs) ->
    if attrs.coordinate_x is null or attrs.coordinate_y is null
      return 'coordinate_x and coordinate_ymust not be null'

  isHeader: () ->
    @.get('coordinate_x') == @.get('current_coordinate_x') and @.get('coordinate_y') == @.get('current_coordinate_y')

  createShipElement: (dimension, panelView) =>
    # Create a ship element for the canvas
    id = @.get('id')
    x = @.get('coordinate_x')
    y = @.get('coordinate_y')
    size = @.get('ship_size')
    alignment = @.get('alignment')
    shipWidth = shipHeigth = dimension



    if panelView  # Seen by other people
      @panel = panelView
      if @.get('status') is 'hit'
        color = 'red'
      else if @.get('status') is 'missed'
        color = 'gray'
      else
        color = 'blue'

      # Draw the marked target
      is_marked = @panel.options.targets.where({user_id: @.get('user_id'), x: @.get('coordinate_x'), y: @.get('coordinate_y')})
#      @panel.options.targets.each(target)->
#        console.log("000000")
#        console.log(target.attrib)
#        if target.get('user_id') is @.get('user_id') and target.get('x') is @.get('coordinate_x') and target.get('y') is @.get('coordinate_y')
#          is_marked = true
#      # Change the color
      if is_marked.length > 0
        @.set({is_targeted: true})
        color = 'green'

      shooter_id_text = if @.get('shooter_id') then @.get('shooter_id') else ""

      ### Create and return a rectangular instance ###
      @rect = new Kinetic.Text({
        x: x * dimension,
        y: y * dimension,
        width: shipWidth,
        height: shipHeigth,
        fill: color,
        stroke: 'black',
        strokeWidth: 0.5,
        name: "ship"
        id: id,
        text: shooter_id_text,
        textFill: 'white',
        fontSize: 12,
      })

      # Bind on the grid that its status is null. Hit and missed show that this grid is hit
      if @.get('status') is null
        # Bind click
        @rect.on 'click', (e)=>
          if not @.get('is_targeted')
            # Check if the target can add
            if (@panel.getTargetSize() < @panel.getMaxSalvo() )
              # Mark as a target
              e.shape.setFill('green')
              @.set({is_targeted: true})
              @panel.addTarget(@.get('user_id'), @.get('coordinate_x'), @.get('coordinate_y') )
          else
            # Remove the target
            e.shape.setFill('blue')
            @.set({is_targeted: false})
            @panel.removeTarget(@.get('user_id'), @.get('coordinate_x'), @.get('coordinate_y') )

          @panel.options.layerShip.draw()

    else # if panelView

      if @.get('grid_type') is 'ship'
        if @.get('status') is 'hit'
          color = 'red'
        else if @.get('status') is 'missed'
          color = 'gray'
        else
          color = 'yellow'
      else
        if @.get('status') is 'hit'
          color = 'gray'
        else
          color = 'blue'

      shooter_id_text = if @.get('shooter_id') then @.get('shooter_id') else ""
      ### Create and return a rectangular instance ###
      @rect = new Kinetic.Text({
        x: x * dimension,
        y: y * dimension,
        width: shipWidth,
        height: shipHeigth,
        fill: color,
        stroke: 'black',
        strokeWidth: 0.5,
        name: "ship"
        id: id,
        text: shooter_id_text,
        textFill: 'white',
        fontSize: 12,
      })


    # Returned
    @rect

class Battleship.Collections.GridsCollection extends Backbone.Collection
  model: Battleship.Models.Grid
  initialize: (props) ->
    @customURL = props.customURL
  url: ()->
    return @customURL
