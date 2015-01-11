###*
 * Marker Module for Leaflet
 * Props:
 *   @props.mapContainer = leaflet map parent
 *   @props.position     = latitude, longitude array
 * State:
 *   @state.markerContainer = leaflet marker instance
###


Utils = require "../Mixins/Utils.coffee"

Marker = React.createClass
  mixins : [Utils]
  initMarker: ->
    Marker = L.marker @props.position
    Marker.addTo @props.mapContainer
    return Marker
  componentWillMount: ->
    @setState markerContainer: @initMarker()
  componentWillUnmount: ->
    console.log "destroy marker"
    @props.mapContainer.removeLayer @state.markerContainer
  componentWillUpdate: (nextProps, nextState) ->
    if nextProps.position != @props.position
      @state.markerContainer.setLatLng nextProps.position
  render: ->
    @getChildrenWithProps
      markerContainer: @state.markerContainer
      mapContainer: @props.mapContainer

module.exports = Marker