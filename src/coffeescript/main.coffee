###*
 * MAP Controller
###

Reflux = require 'reflux'
MarkerStore = require './store/MarkerStore.coffee'

MapJsonController = require "./component/MapJsonController.coffee"

React.render(
  <MapJsonController/>
  document.getElementById("content")
)
  

console.log "test ok"