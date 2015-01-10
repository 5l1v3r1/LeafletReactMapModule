Map = require "./MapModule/MapModule.coffee"
Marker = require "./MapModule/ElementModule/MarkerModule.coffee"
PruneMarker = require "./MapModule/ElementModule/PruneMarkerModule.coffee"
Popup = require "./MapModule/ElementModule/PopupModule.coffee"
Layer = require "./MapModule/ElementModule/LayerModule.coffee"
Cluster = require "./MapModule/ElementModule/ClusterModule.coffee"


MapController = React.createClass
  getInitialState: ->
    {
      positions:  require "./JRPdata.coffee"
    }
  render: ->

    position = [-0.789275,113.921327]
    console.log "render controller"
    
    #render children
    children = @state.positions.map (val, index)->
      <PruneMarker position={val} key={index}>
          <b>Test Child</b>
      </PruneMarker>
      
    # render map
    <Map position={position} id="map">
      <Layer/>
      <Cluster>
        {children}
      </Cluster>
    </Map>

module.exports = MapController