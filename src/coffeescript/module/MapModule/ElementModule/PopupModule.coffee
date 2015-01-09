###*
 * Marker Module for Leaflet
 * parent: @props.markerContainer
###

Popup = React.createClass
  initMarker: ->
    @props.markerContainer.bindPopup("Loading")
  componentWillMount: ->
    @setState(
      popUp: @initMarker()
    )
    @props.markerContainer.addOneTimeEventListener "click", =>
      setTimeout (=>
        @props.markerContainer.setPopupContent @props.children
        ), 1000

  componentWillUnmount: ->
    @props.markerContainer.unbindPopup()
    @props.markerContainer.clearAllEventListeners()

  render: ->
    null


module.exports = Popup