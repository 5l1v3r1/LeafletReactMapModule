###*
 * PruneMarker Module for Leaflet
 * Props:
 *   @props.mapContainer = leaflet map parent
 *   @props.clusterContainer = prune cluster parent
 *   @props.position     = latitude, longitude array
 * State:
 *   @state.markerContainer = leaflet marker instance
###

Utils = require "../Mixins/Utils.coffee"

PruneMarker = React.createClass
  mixins : [Utils]
  getInitialState: ->
    popUp: false
  initMarker: ->
    #console.log @props.children
    Marker = new PruneCluster.Marker(@props.position[0], @props.position[1])
    #console.log  @props.popUp
    if @props.popUp? && @props.popUp = true
      Marker.data.popup = @props.children
    @props.clusterContainer.RegisterMarker(Marker)
    return Marker
  componentWillMount: ->
    @setState markerContainer: @initMarker()
  componentWillUnmount: ->
    console.log "destroy marker"
    @props.clusterContainer.RemoveMarkers @state.markerContainer
  componentWillUpdate: (nextProps, nextState) ->
    if nextProps.position != @props.position
      @state.markerContainer.Move nextProps.position
      @props.clusterContainer.ProcessView()
  render: ->
    return null

module.exports = PruneMarker