###*
 * Leaflet Map Container
###

Utils = require "./Mixins/Utils.coffee"

Map = React.createClass
  mixins: [Utils]
  initMap: ->
    map = L.map(this.getDOMNode()).setView([-0.789275,113.921327], 5)
    @setState 
      map: map
  componentDidMount: ->
    @initMap()
  render: ->
    console.log @state
    #map is div id by react
    if not (@state? && @state.map?)
      children = null
    else
      children = @getChildrenWithProps
        markerContainer: @state.markerContainer
        mapContainer: @state.map
    <div className={@props.className} id={@props.id}>
      {children}
    </div>
    
module.exports = Map