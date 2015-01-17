###*
 * MAP Controller
###

Reflux = require 'reflux'
Actions = require './actions/actions.coffee'


MarkerStore = require './store/MarkerStore.coffee'

MapJsonController = require "./component/MapJsonController.coffee"

React.render(
  <MapJsonController/>
  document.getElementById("content")
)
  
window.action = Actions



console.log "test ok"