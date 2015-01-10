###*
 * Popup Module for Leaflet
 * parent: @props.markerContainer
###
Map = require "../MapModule.coffee"
Layer = require "./LayerModule.coffee"
Marker = require "./MarkerModule.coffee"


Popup = React.createClass
  
  popUpEvent:
    popupopen : ->
      @_renderid = document.getElementById(@props.id)
      React.render(@props.children, @_renderid)
    popupclose : ->
      React.unmountComponentAtNode(@_renderid)
      console.log "cleanup"

  handleClick: ->
    console.log "click handler"
    @state.count += 1
  
  initPopup: ->
    @props.markerContainer.bindPopup("Loading")
  
  getInitialState: ->
    loaded: 0
    count: 0
  
  componentWillMount: ->
    console.log "popup will mount"
    @setState popUp: @initPopup()
    popContent = React.renderToString(<div id={@props.id}></div>)
    @props.markerContainer.setPopupContent(popContent)
  
  componentDidMount: ->
    @props.markerContainer.addEventListener @popUpEvent, @
  
  componentWillUnmount: ->
    console.log "destroy popup marker event"
    @props.markerContainer.unbindPopup()
    @props.markerContainer.removeEventListener @popUpEvent, @
  
  render: ->
    #console.log "render"
    null


module.exports = Popup