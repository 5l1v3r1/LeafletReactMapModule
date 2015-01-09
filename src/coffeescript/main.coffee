Map = require "./module/MapModule.coffee"
Marker = require "./module/MarkerModule.coffee"
MapController = require "./module/MapController.coffee" 

console.log("ok")

React.render(
  <MapController/>
  document.getElementById("content")
)
  
