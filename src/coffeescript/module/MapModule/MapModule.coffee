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
  initEvents: (mapInstance)->
    _mapcon = mapInstance
    for event, action of @props
      if event[0..1] == "on"
        _action = action
        mapInstance.on event[2..].toLowerCase(), (e) -> _action(e,_mapcon)
  cleanEvents: (mapInstance) ->
    _mapcon = mapInstance
    for event, action of @props
      if event[0..1] == "on"
        _action = action
       mapInstance.on event[2..].toLowerCase(), (e) -> _action(e,_mapcon)
  initMap: ->
    map = L.map(this.getDOMNode(), @props.mapOptions)
    @initEvents(map)
    map.setView(@props.position, 13)
    @setState mapContainer: map

  shouldComponentUpdate: (nextProps, nextState) ->
    shouldUpdate = true

    if nextProps.position != @props.position
      @state.mapContainer.setView(nextProps.position)
      shouldUpdate = false

    return shouldUpdate

  componentWillUpdate: (nextProps, nextState) ->
    
  componentDidMount: ->
    console.log "from module componentDidMount"
    @initMap()
    #@state.mapContainer.

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