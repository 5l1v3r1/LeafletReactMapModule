###*
 * Cluster Module for Leaflet
 * Props:
 *   @props.mapContainer = leaflet map parent
 *   @props.position     = latitude, longitude array
 * State:
 *   @state.clusterContainer = leaflet marker instance
 * Inherit:
 *   mapContainer
 *   clusterContainer
###


Utils = require "../Mixins/Utils.coffee"

PruneCluster = React.createClass
  mixins : [Utils]
  initCluster: ->
    pruneCluster = new PruneClusterForLeaflet()
    @props.mapContainer.addLayer pruneCluster
    #window.prune = pruneCluster
    return pruneCluster
  componentWillMount: ->
    @setState clusterContainer : @initCluster()
  componentDidMount: ->
    @state.clusterContainer.ProcessView()
  componentWillUnmount: ->
    delete @state.clusterContainer
  render: ->
    children = @getChildrenWithProps
      mapContainer: @props.mapContainer
      clusterContainer: @state.clusterContainer
    #noscript error
    if (Array.isArray children)
      children
    else
      <div>
        {children}
      </div>

module.exports = PruneCluster