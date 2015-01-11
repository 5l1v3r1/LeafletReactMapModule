Map = require "./MapModule/MapModule.coffee"
Marker = require "./MapModule/ElementModule/MarkerModule.coffee"
PruneMarker = require "./MapModule/ElementModule/PruneMarkerModule.coffee"
Popup = require "./MapModule/ElementModule/PopupModule.coffee"
Layer = require "./MapModule/ElementModule/LayerModule.coffee"
PruneCluster = require "./MapModule/ElementModule/ClusterModule.coffee"
PrunePopup = require "./MapModule/ElementModule/PrunePopupModule.coffee"

MapController = React.createClass
  getInitialState: ->
    {
      positions:  require "./JRPdata.coffee"
    }
  render: ->

    position = [-7.803252078318418, 110.37484495000001]
    console.log "render controller"
    
    #render children
    children = @state.positions.map (val, index)->
      <PruneMarker position={val} key={index}>
          <button onClick={(e)-> console.log e} >
            <i>hahaha</i>
          </button>
      </PruneMarker>
      
    # render map
    <Map position={position} id="map">
      <Layer/>
      <PruneCluster>
        <PrunePopup>
          {children}
        </PrunePopup>
      </PruneCluster>
    </Map>

module.exports = MapController