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
    window.mapcon = @
    {
      positions:  require "./JRPdata.coffee"
      position: [-7.803252078318418, 110.37484495000001]
    }
  _onMove: ->
    console.log "on move end"
  render: ->
    #position = [-7.803252078318418, 110.37484495000001]
    console.log "render controller"
    
    iframestyle =
      "border-style": "none"
      "width": "100%"
      "height": "300px"

    #render children
    children = @state.positions.map (val, index)->
      <PrunePopup key={index}>
        <PruneMarker position={val}>
            <div>
              <iframe title="pannellum panorama viewer" style={iframestyle} allowfullscreen=""  src="http://127.0.0.1:8000/src/pannellum.htm?config=../examples/config.json"></iframe>
            </div>
        </PruneMarker>
      </PrunePopup>

    # render map
    <Map className="custom-popup" position={@state.position} id="map">
      <Layer/>
      <PruneCluster>
      <PruneLayerJSON/>
        {children}
      </PruneCluster>
    </Map>

module.exports = MapController