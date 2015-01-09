###*
 * Marker Module for Leaflet
 * parent: @props.markerContainer
###

Test = React.createClass
  handleClick: ->
    console.log "handle click"
  componentWillUnmount: ->
    console.log "TEST UNMOUNT"
  render: ->
    <b onClick={@handleClick}>TEST</b>


Popup = React.createClass
  handleClick: ->
    console.log "click handler"
  initMarker: ->
    @props.markerContainer.bindPopup("Loading")
  getInitialState: ->
    loaded: 0
  componentWillMount: ->
    @setState popUp: @initMarker()

    popContent = React.renderToString(<div id={@props.id}></div>)
    @props.markerContainer.setPopupContent(popContent)

    ## warning: cleanup
    @props.markerContainer.on "popupopen", =>
      React.render(<Test key={@props.id} />, document.getElementById(@props.id))
      #$("#"+@props.id).on "click", (e) -> console.log e
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