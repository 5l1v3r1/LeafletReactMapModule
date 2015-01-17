Reflux = require 'reflux'
Actions = require '../actions/actions.coffee'

Map = require "../module/MapModule/MapModule.coffee"
Marker = require "../module/MapModule/MarkerModule.coffee"
PruneMarker = require "../module/MapModule/PruneMarkerModule.coffee"
Popup = require "../module/MapModule/PopupModule.coffee"
Layer = require "../module/MapModule/LayerModule.coffee"
PruneCluster = require "../module/MapModule/ClusterModule.coffee"
PrunePopup = require "../module/MapModule/PrunePopupModule.coffee"
PruneLayerJSON = require "./JsonLayerController.coffee"

MapController = React.createClass
  mixins: [Reflux.listenTo(Actions.receivedAPIData, "_receivedAPI")]
  getInitialState: ->
    window.mapcon = @
    {
      positions: []
      position: [-7.803252078318418, 110.37484495000001]
    }
  _onMove: ->
    console.log "on move end"
  _receivedAPI: (data)->
    console.log data
    @setState
      positions: data
    Actions.processClusterView()
    console.log "send proc"
  _onLoad: ->
    console.log "onload"
    Tabletop.init 
      key: 'https://docs.google.com/spreadsheets/d/1oYfcgiWZAkuzdD80tJcWfIXhea6RgJU8S3R5TN2ghzc/pubhtml?gid=862036769&single=true',
      callback: Actions.receivedAPIData,
      simpleSheet: true
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
      pos = [parseFloat(val.latitude), parseFloat(val.longitude)]

      pano_frame = null
      if val.panorama_file != "" then pano_frame = <iframe title="pannellum panorama viewer" style={iframestyle} allowFullScreen="true"  src="http://maps.lifepatch.org/v2/pannellum.htm?config=./#{val.panorama_file}/config.json"></iframe>

      <PrunePopup key={index}>
        <PruneMarker position={pos}>
            <div>
                  {pano_frame}
                  <p className="bg-danger">{val.pengambilan}: {val.nama_daerah} <br/> temperatur: {val.temperature} ph : {val.ph}  </p>
            </div>
        </PruneMarker>
      </PrunePopup>

    # render map
    <Map className="custom-popup" onLoad={@_onLoad} position={@state.position} id="map">
      <Layer/>
      <PruneCluster>
      <PruneLayerJSON selected="id" />
        {children}
      </PruneCluster>
    </Map>

module.exports = MapController