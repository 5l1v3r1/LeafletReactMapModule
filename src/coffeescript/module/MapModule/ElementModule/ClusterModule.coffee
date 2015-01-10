###*
 * Cluster Module for Leaflet
 * Props:
 *   @props.mapContainer = leaflet map parent
 *   @props.position     = latitude, longitude array
 * State:
 *   @state.markerContainer = leaflet marker instance
###

Utils = require "../Mixins/Utils.coffee"

Cluster = React.createClass
  mixins : [Utils]
  initCluster: ->
    pruneCluster = new PruneClusterForLeaflet()
    @props.mapContainer.addLayer pruneCluster
    return pruneCluster
  componentWillMount: ->
    @setState clusterContainer : @initCluster()
  componentDidMount: ->
    @state.clusterContainer.ProcessView()
  render: ->
    window.cluster =  @state.clusterContainer
    children = @getChildrenWithProps
      mapContainer: @props.mapContainer
      clusterContainer: @state.clusterContainer
    #noscript error
    <div>
      {children}
    </div>

module.exports = Cluster