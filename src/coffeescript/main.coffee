###*
 * MAP Controller
###

MapController = require "./module/MapController.coffee"

React.render(
  <MapController/>
  document.getElementById("content")
)
  

console.log "test ok"