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
    #console.log data
    for marker, idx in data
      hash = marker.hash
      if not (@_markersCache.hasOwnProperty(hash)) #if received marker is not in cache
        @_markersCache[hash] = new PruneCluster.Marker(marker.lat, marker.lon)  #create and add marker to cache
        @props.clusterContainer.RegisterMarker @_markersCache[hash]
        redraw = true
    if redraw?
      @props.clusterContainer.ProcessView()
      #console.log "redraw" 

  _isBoundsCached: (bounds) ->
    if @_maxBounds? #if not an initial data
      #if bound already cached lets load marker from cache
      if @_maxBounds.contains(bounds) == true
        return true
      else
        #@_maxBounds.extend(bounds)
        console.log "extend"
        return false
    else
      @_maxBounds = bounds
      return false

  _getMarkerFromCurrentBounds: ->
    currentBounds = @props.mapContainer.getBounds()
    cached = @_isBoundsCached(currentBounds)
    console.log 'local cached', cached
    if cached == false then Actions.getMarkerBound(currentBounds)

  componentDidMount: -> #set initial map bounds
    window.cachedebug = @_markersCache
    @_getMarkerFromCurrentBounds()
    @props.mapContainer.on "moveend", @_getMarkerFromCurrentBounds

  componentWillUnmount: ->
    @props.mapContainer.removeLayer @state.layerContainer
      
  render: ->
    null

module.exports = PruneLayerJSON