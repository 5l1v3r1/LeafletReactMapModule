Reflux = require 'reflux'
actions = require '../actions/actions.coffee'

Map = require "../module/MapModule/MapModule.coffee"
Marker = require "../module/MapModule/MarkerModule.coffee"
PruneMarker = require "../module/MapModule/PruneMarkerModule.coffee"
Popup = require "../module/MapModule/PopupModule.coffee"
Layer = require "../module/MapModule/LayerModule.coffee"
PruneCluster = require "../module/MapModule/ClusterModule.coffee"
PrunePopup = require "../module/MapModule/PrunePopupModule.coffee"
PruneLayerJSON = require "./JsonLayerController.coffee"

MapController = React.createClass
  getInitialState: ->
    window.mapcon = @
    {
      positions:  require "../store/JRPdata.coffee"
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
    ##              <iframe title="pannellum panorama viewer" style={iframestyle} allowFullScreen="true"  src="http://127.0.0.1:8000/src/pannellum.htm?config=../examples/config.json"></iframe>

    children = @state.positions.map (val, index)->
      <PrunePopup key={index}>
        <PruneMarker position={val}>
            <div>
              <button onClick={ -> actions.login()} >test click me</button>
            </div>
        </PruneMarker>
      </PrunePopup>

    # render map
    <Map className="custom-popup" position={@state.position} id="map">
      <Layer/>
      <PruneCluster>
      <PruneLayerJSON selected="id" />
        {children}
      </PruneCluster>
    </Map>

module.exports = MapController