Map = require "./MapModule.coffee"
Marker = require "./MarkerModule.coffee"

MapController = React.createClass
  render: ->
    <Map>
      <Marker position={[-1.3182430568620136, 110.390625]} />
      <Marker position={[-9.10209673872643,104.4140625]}/>
      <Marker position={[-6.577303118123875,107.4462890625]}/>
    </Map>

module.exports = MapController