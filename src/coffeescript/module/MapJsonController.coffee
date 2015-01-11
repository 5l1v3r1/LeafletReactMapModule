Map = require "./MapModule/MapModule.coffee"
Marker = require "./MapModule/ElementModule/MarkerModule.coffee"
PruneMarker = require "./MapModule/ElementModule/PruneMarkerModule.coffee"
Popup = require "./MapModule/ElementModule/PopupModule.coffee"
Layer = require "./MapModule/ElementModule/LayerModule.coffee"
PruneCluster = require "./MapModule/ElementModule/ClusterModule.coffee"
PrunePopup = require "./MapModule/ElementModule/PrunePopupModule.coffee"
PruneLayerJSON = require "./MapModule/ElementModule/PruneLayerJsonModule.coffee"

MapController = React.createClass
  getInitialState: ->
    {
      positions:  require "./JRPdata.coffee"
    }
  _onMove: ->
    console.log "on move end"
  render: ->

    position = [-7.803252078318418, 110.37484495000001]
    console.log "render controller"
    
    #render children
    children = @state.positions.map (val, index)->
      <PrunePopup key={index}>
        <PruneMarker position={val}>
            <button onClick={(e)-> console.log e} >
              <i>hahaha</i>
            </button>
        </PruneMarker>
      </PrunePopup>

    # render map
    <Map position={position} id="map">
      <Layer/>
      <PruneCluster>
      <PruneLayerJSON/>
        {children}
      </PruneCluster>
    </Map>

module.exports = MapController