###*
 * Leaflet Map Container
###

Utils = require "./Mixins/Utils.coffee"

Map = React.createClass
  mixins: [Utils]
  initMap: ->
    map = L.map(this.getDOMNode()).setView([-0.789275,113.921327], 5)
    @setState map: map
  componentDidMount: ->
    @initMap()
  render: ->
    if not map?
      children = null
    else
      children = @getChildrenWithProps
        markerContainer: @state.markerContainer
        mapContainer: @state.map
    <div id="map">
      {children}
    </div>
    
module.exports = Map