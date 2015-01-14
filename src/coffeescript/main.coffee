###*
 * MAP Controller
###

Reflux = require 'reflux'

console.log "okess"

MapJsonController = require "./component/MapJsonController.coffee"

React.render(
  <MapJsonController/>
  document.getElementById("content")
)
  

console.log "test ok"