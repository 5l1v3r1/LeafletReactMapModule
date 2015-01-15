###*
 * Marker Module for Leaflet
 * Props:
 *   @props.mapContainer = leaflet map parent
 *   @props.position     = latitude, longitude array
 *   TODO:
 *   tileUrl
 *   maxZoom
 *   attribution
 *   id
 * State:
 *   @state.markerContainer = leaflet marker instance
###

Reflux = require 'reflux'
Actions = require '../actions/actions.coffee'


PruneLayerJSON = React.createClass
  mixins: [Reflux.listenTo(Actions.receivedMarkerData, "_receivedMarkerData")]
  _markersCache: {}

  _receivedMarkerData: (data) ->
    console.log data
    for hash, marker of data
      if marker.loaded
        if not (@_markersCache[hash])
          @_markersCache[hash] = new PruneCluster.Marker(marker.lat, marker.lon)
          @props.clusterContainer.RegisterMarker @_markersCache[hash]
      else
        if (@_markersCache[hash])
          @props.clusterContainer.RemoveMarkers([@_markersCache[hash]])
          delete @_markersCache[hash]

    @props.clusterContainer.ProcessView()

  _getMarkerFromCurrentBounds: ->
    Actions.getMarkerBound(@props.mapContainer.getBounds())

  componentDidMount: -> #set initial map bounds
    @_getMarkerFromCurrentBounds()
    @props.mapContainer.on "moveend", @_getMarkerFromCurrentBounds

  componentWillUnmount: ->
    @props.mapContainer.removeLayer @state.layerContainer
      
  render: ->
    null

module.exports = PruneLayerJSON