Map = require "./MapModule/MapModule.coffee"
Marker = require "./MapModule/ElementModule/MarkerModule.coffee"
Popup = require "./MapModule/ElementModule/PopupModule.coffee"
Layer = require "./MapModule/ElementModule/LayerModule.coffee"

MapController = React.createClass
  getInitialState: ->
    window.mapcon = @
    {
      positions: [
        [-9.10209673872643,104.4140625],
        [-6.577303118123875,107.4462890625],
        [-6.577303118123875,108.4462890625],
        [-7.577303118123875,108.4462890625],
      ]
    }
  render: ->
    console.log "render controller"
    children = @state.positions.map (val, index)->
      return (
        <Marker position={val} key={index}>
          <Popup>
            lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor 
          </Popup>
        </Marker>
      )

    <Map>
      <Layer/>
      {children}
    </Map>

module.exports = MapController