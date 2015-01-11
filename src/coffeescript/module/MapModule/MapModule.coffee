###*
 * Leaflet Map Container
 *   @state.mapContainer = leaflet map parent
###

Utils = require "./Mixins/Utils.coffee"
Test = require "./Mixins/Test.coffee"

Map = React.createClass
  mixins: [Utils, Test]
  getDefaultProps: ->
    mapOptions:
      minZoom: 1
      maxZoom: 17
  initEvents: ->
    _mapcon = @state.mapContainer
    for event, action of @props
      if event[0..1] == "on"
        _action = action
        @state.mapContainer.on event[2..].toLowerCase(), (e) -> _action(e,_mapcon)
  cleanEvents: ->
    _mapcon = @state.mapContainer
    for event, action of @props
      if event[0..1] == "on"
        _action = action
        @state.mapContainer.on event[2..].toLowerCase(), (e) -> _action(e,_mapcon)
  initMap: ->
    map = L.map(this.getDOMNode(), @props.mapOptions).setView(@props.position, 13)
    @setState mapContainer: map
  componentDidMount: ->
    console.log "from module componentDidMount"
    @initMap()
    @initEvents()
  componentWillUnmount: ->
    console.log "map unmount"
    @cleanEvents()
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