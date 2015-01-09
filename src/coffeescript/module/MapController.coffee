Map = require "./MapModule/MapModule.coffee"
Marker = require "./MapModule/ElementModule/MarkerModule.coffee"
Popup = require "./MapModule/ElementModule/PopupModule.coffee"
Layer = require "./MapModule/ElementModule/LayerModule.coffee"

MapController = React.createClass
  getInitialState: ->
    {
      positions: [
        [-9.10209673872643,104.4140625],
        [-6.577303118123875,107.4462890625],
        [-6.577303118123875,108.4462890625],
        [-7.577303118123875,108.4462890625],
        [-8.577303118123875,108.4462890625],
        [-9.577303118123875,108.4462890625],
        [-4.577303118123875,108.4462890625],

      ]
    }
  render: ->
    console.log "render controller"
    children = @state.positions.map (val, index)->
      return (
        <Marker position={val} key={index}>
          <Popup id={"pop-"+index}>
            <div id={"pop-"+index}>
              <button name="test">Click Me</button>
            </div>
          </Popup>
        </Marker>
      )

    <Map>
      <Layer/>
      {children}
    </Map>

module.exports = MapController