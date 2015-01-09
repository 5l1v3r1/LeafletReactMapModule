Marker = React.createClass
  initMarker: ->
    Marker = L.marker @props.position
    Marker.addTo @props.mapContainer
    return Marker
  componentWillMount: ->
    @setState(
      marker: @initMarker()
    )
  ##  @initMarker()
  ## console.log "marker: will mount"
  ## console.log @props.mapContainer
  render: ->
    null


module.exports = Marker