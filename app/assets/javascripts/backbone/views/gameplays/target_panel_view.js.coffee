Battleship.Views.Gameplays ||= {}

class Battleship.Views.Gameplays.TargetPanelView extends Backbone.View
  template: JST["backbone/templates/gameplays/targetpanel"]

  events: {
    "click #fireTarget": "fireTarget"
  #  "keypress input[type=text]": "pressSubmitMessage"

  },

  initialize: () ->
#    @options.targets.bind('reset', @addAll)
    @options.targets.bind('add', @addOne)
    @options.targets.bind('remove', @reRender, @)
    @options.room.bind('gameplay', @render, @)

    @isFired = false
#    @options.grids

  addAll: () =>
    @options.targets.each(@addOne)

  addOne: (model) =>
    view = new Battleship.Views.Gameplays.TargetView({model : model})
    @$el.append(view.render().el)

  render: =>
    myTurn =  @options.room.isTurn()
    $(@el).html(@template(targets: @options.targets.toJSON(), is_turn: myTurn ))
    @addAll()
    return this

  reRender: ()->
    console.log('re-render')
    $("#TargetView").html(@.render().el)

  fireTarget: ()->
    @isFired = true
    @options.targets.fire()
    $("#TargetView").html("")
    @options.targets.reset null
#    @options.grids.fetch()

  initializeTimer: ()=>
    if $("#game_play_timer").length > 0
      $("#game_play_timer").pietimer({
        seconds: 30,
        color: 'rgba(0,102,204,0.8)',
        height: 100,
        width: 100
      },
      () =>
        if @isFired is false
          @fireTarget()
      )
      $('#game_play_timer').pietimer('start')

