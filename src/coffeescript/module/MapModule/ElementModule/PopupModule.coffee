###*
 * Marker Module for Leaflet
 * parent: @props.markerContainer
###

Popup = React.createClass
  handleClick: ->
    console.log "click handler"
  initMarker: ->
    @props.markerContainer.bindPopup("Loading")
  getInitialState: ->
    loaded: 0
  componentWillMount: ->
    @setState popUp: @initMarker()

    popContent = React.renderToString(@props.children)
    @props.markerContainer.setPopupContent(popContent)

    ## warning: cleanup
    @props.markerContainer.on "popupopen", =>
      $("#"+@props.id).on "click", (e) => console.log e
    @props.markerContainer.on "popupclose", =>
      console.log "cleanup"
      $("#"+@props.id).off "click"


  componentDidMount: ->

  componentWillUnmount: ->
    @props.markerContainer.unbindPopup()
    @props.markerContainer.clearAllEventListeners()

  render: ->
    null


module.exports = Popup