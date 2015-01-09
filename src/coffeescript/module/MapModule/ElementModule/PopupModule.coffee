###*
 * Marker Module for Leaflet
 * parent: @props.markerContainer
###
Map = require "../MapModule.coffee"
Layer = require "./LayerModule.coffee"
Marker = require "./MarkerModule.coffee"

Test = React.createClass
  handleClick: ->
    #console.log "handle click"
    @props.onClick()
    @setState
      count: @state.count+1
  getInitialState: ->
    count: @props.count
  componentWillUnmount: ->
    console.log "TEST UNMOUNT"
  render: ->
    <button onClick={@handleClick}>TEST {@state.count}</button>


Popup = React.createClass
  handleClick: ->
    console.log "click handler"
    @state.count += 1
  initMarker: ->
    @props.markerContainer.bindPopup("Loading")
  getInitialState: ->
    loaded: 0
    count: 0
  componentWillMount: ->
    console.log "popup will mount"
    @setState popUp: @initMarker()

    popContent = React.renderToString(<div id={@props.id}></div>)
    @props.markerContainer.setPopupContent(popContent)

  componentDidMount: ->
    console.log "componentDidMount"
    ## warning: cleanup
    @props.markerContainer.on "popupopen", =>
      @_renderid = document.getElementById(@props.id)
      React.render(
        <Map className="map-full" count={@state.count} onClick={@handleClick}>
          <Layer/>
          <Marker position={[-4.577303118123875,108.4462890625]}/>
        </Map>, @_renderid)
      #$("#"+@props.id).on "click", (e) -> console.log e
    @props.markerContainer.on "popupclose", =>
      React.unmountComponentAtNode(@_renderid)
      console.log "cleanup"
      #$("#"+@props.id).off "click"

  componentWillUnmount: ->
    #todo: unmount child
    @props.markerContainer.unbindPopup()
    @props.markerContainer.clearAllEventListeners()

  render: ->
    console.log "render"
    null


module.exports = Popup