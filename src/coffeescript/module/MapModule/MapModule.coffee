###*
 * Leaflet Map Container
 *   @state.mapContainer = leaflet map parent
###

Utils = require "./Mixins/Utils.coffee"
Test = require "./Mixins/Test.coffee"

Map = React.createClass
  mixins: [Utils, Test]
  initMap: ->
    map = L.map(this.getDOMNode()).setView(@props.position, 5)
    @setState
      mapContainer: map
  componentDidMount: ->
    console.log "from module componentDidMount"
    @initMap()
  componentWillUnmount: ->
    console.log "map unmount"
    #@props.map.remove()
  render: ->
    #map is div id by react
    if not (@state? && @state.mapContainer?)
      children = null
    else
      children = @getChildrenWithProps
        mapContainer: @state.mapContainer

    <div className={@props.className} id={@props.id}>
      {children}
    </div>
    
module.exports = Map