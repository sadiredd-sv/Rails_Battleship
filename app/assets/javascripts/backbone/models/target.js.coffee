class Battleship.Models.Target extends Backbone.Model
  paramRoot: 'target'

  defaults:
    user_id: null
    x: null
    y: null


class Battleship.Collections.TargetsCollection extends Backbone.Collection
  model: Battleship.Models.Target
  initialize: (props) ->
    @customURL = props.customURL
  url: ()->
    return @customURL
  fire: ()->
    console.log(@.models)
    target = []
    _.each @.models, (m)=>
      target.push(m.attributes)

    console.log(target.length)

    targets = new Battleship.Models.Salvo({customURL: @.url()})
    targets.set({targets: target})
    targets.save(
      success: (data) =>
        console.log('asdfasdf')
        # Trigger grid model to fetch from the server
        #        @options.grids.fetch()
      error: (data, jqXHR) =>
        #        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
#    @.create(targets.toJSON(),
#      success: (data) =>
#        # Trigger grid model to fetch from the server
##        @options.grids.fetch()
#      error: (data, jqXHR) =>
##        @model.set({errors: $.parseJSON(jqXHR.responseText)})
#    )


