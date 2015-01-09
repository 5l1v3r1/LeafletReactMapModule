class MapRouter extends Marionette.AppRouter.extend()
  initialize : ->
    console.log "MapRouter init"
    @appRoutes =
      "hello/:x/:y/:z" : "helloFunc"


module.exports = MapRouter