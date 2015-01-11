###*
 * Marker Module for Leaflet
 * Props:
 *   @props.mapContainer = leaflet map parent
 *   @props.position     = latitude, longitude array
 *
 * 
 *   TODO:
 *   tileUrl
 *   maxZoom
 *   attribution
 *   id
 *
 * 
 * State:
 *   @state.markerContainer = leaflet marker instance
###

Utils = require "../Mixins/Utils.coffee"

PruneLayerJSON = React.createClass
  _createLayer: ->
    layer.addTo @props.mapContainer
    return layer
  _update: ->
    prec = 6
    bb = @props.mapContainer.getBounds()
    sw = bb.getSouthWest()
    ne = bb.getNorthEast()
    bbox = [
      [ parseFloat(sw.lat.toFixed(prec)), parseFloat(sw.lng.toFixed(prec)) ],
      [ parseFloat(ne.lat.toFixed(prec)), parseFloat(ne.lng.toFixed(prec)) ]
    ]
    bbox = L.Util.template("search.php?lat1={lat1}&lat2={lat2}&lon1={lon1}&lon2={lon2}",
        {
          lat1: bbox[0][0]
          lon1: bbox[0][1]
          lat2: bbox[1][0]
          lon2: bbox[1][1]
        })
    console.log bbox

  _onMove: ->
    #newZoom = @props.mapContainer.getZoom()
    #newCenter = @props.mapContainer.getCenter()
    newBounds = @props.mapContainer.getBounds()
    if @_maxBounds.contains(newBounds) == false
      console.log "update cache"

    @_maxBounds.extend(newBounds)
    @_update()

  #getInitialState: ->
  #  layerContainer: @_createLayer()
  componentWillMount: ->
  componentDidMount: ->
    @props.mapContainer.on "moveend", @_onMove
    @_center = @props.mapContainer.getCenter()
    @_maxBounds = @props.mapContainer.getBounds()
  componentWillUnmount: ->
    console.log "destroy layer"
    @props.mapContainer.removeLayer @state.layerContainer
      
  render: ->
    null

module.exports = PruneLayerJSON