###*
 * PrunePopup Module for Leaflet
 * Manage the child element
 * parent: @props.markerContainer
###

Utils = require "../Mixins/Utils.coffee"


PrunePopup = React.createClass
  mixins : [Utils]

  initPopup: ->
    @props.clusterContainer.PrepareLeafletMarker = (marker, data) ->
      
      popContainer = '<div id="popc"></div>'

      if marker.getPopup()
        marker.setPopupContent(popContainer)
      else
        marker.bindPopup(popContainer)

      marker.on "popupopen", =>
        console.log "popupopen"
        @_popc = document.getElementById('popc')
        React.render data.popup, @_popc
      marker.on "popupclose", =>
        console.log "popupclose"
        React.unmountComponentAtNode @_popc
        #console.log document.getElementById('wew')
      marker.on "remove", ->
        console.log "cleanup"
        marker.unbindPopup()
        marker.removeEventListener()

  
  componentWillMount: ->
    @initPopup()
  
  componentDidMount: ->
    #@props.markerContainer.addEventListener @popUpEvent, @
  
  componentWillUnmount: ->
    #console.log "destroy popup marker event"
    #@props.markerContainer.unbindPopup()
    #@props.markerContainer.removeEventListener @popUpEvent, @
  
  render: ->
    children = @getChildrenWithProps
      mapContainer: @props.mapContainer
      clusterContainer: @props.clusterContainer
      popUp: true
    #console.log "render"
    #console.log @props.children
    if (Array.isArray children)
      children
    else
      <div>
        {children}
      </div>


module.exports = PrunePopup