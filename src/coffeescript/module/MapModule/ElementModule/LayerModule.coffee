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

Layer = React.createClass
  initMarker: ->
    layer = L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png',
    {
      maxZoom: 13
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
        '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="http://mapbox.com">Mapbox</a>'
      id: 'examples.map-i875mjb7'
    })
    layer.addTo @props.mapContainer
    return layer
  componentWillMount: ->
    @initMarker()
  render: ->
    null

module.exports = Layer