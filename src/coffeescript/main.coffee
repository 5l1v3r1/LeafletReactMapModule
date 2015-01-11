###*
 * MAP Controller
###

MapJsonController = require "./module/MapJsonController.coffee"

React.render(
  <MapJsonController/>
  document.getElementById("content")
)
  

console.log "test ok"