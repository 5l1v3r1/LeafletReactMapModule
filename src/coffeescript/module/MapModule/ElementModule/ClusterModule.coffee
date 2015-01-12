###*
 * Cluster Module for Leaflet
 * Props:
 *   @props.mapContainer = leaflet map parent
 *   @props.position     = latitude, longitude array
 * State:
 *   @state.clusterContainer = leaflet marker instance
 * Inherit:
 *   mapContainer
 *   clusterContainer
###


Utils = require "../Mixins/Utils.coffee"

PruneClusterLayer = React.createClass
  mixins : [Utils]
  initCluster: ->

    clusterContainer = new PruneClusterForLeaflet()
    @props.mapContainer.addLayer clusterContainer
    #window.prune = pruneCluster
    return clusterContainer
  initPopup: ->
    @state.clusterContainer.PrepareLeafletMarker = (marker, data) ->
      
      if data.popup?
        ## todo: use dynamic
        popContainer = '<div id="popc"></div>'

        if marker.getPopup()
          marker.setPopupContent(popContainer)
        else
          marker.bindPopup popContainer,
            maxWidth: 300
            minWidth: 300
            maxHeight: null
            zoomAnimation: false

        marker.on "popupopen", =>
          console.log "popupopen"
          @_popc = document.getElementById('popc')
          React.render data.popup, @_popc
        marker.on "popupclose", =>
          console.log "popupclose"
          React.unmountComponentAtNode @_popc
          #console.log document.getElementById('wew')
        marker.on "remove", ->
          console.log "cleanup"
          marker.unbindPopup()
          marker.removeEventListener()

  componentWillMount: ->
    @setState clusterContainer : @initCluster()


  componentDidMount: ->
    @initPopup()


    @state.clusterContainer.ProcessView()

    #test = new PruneCluster.Marker( -7.7915465, 110.3634395)
    #@state.clusterContainer.RegisterMarker(test)
    #@state.clusterContainer.ProcessView()

    #testMap = L.layerJSON({
    #  url: 'http://overpass-api.de/api/interpreter?data=[out:json];node({lat1},{lon1},{lat2},{lon2})[amenity=bar];out;',
    #  propertyItems: 'elements',
    #  propertyTitle: 'tags.name',
    #  propertyLoc: ['lat','lon'],
    #  #layerTarget: @state.clusterContainer,
    #  dataToMarker: (latlng, data) =>
    #    console.log latlng.lat, latlng.lon
    #    marker = new PruneCluster.Marker(latlng.lat, latlng.lon)
    #    @state.clusterContainer.RegisterMarker(marker)
    #    return {
    #      marker: marker
    #      onAdd: ->
    #        console.log "strangeee!"
    #      off: ->
    #        console.log "strangeee!"     
    #      getLatLng: ->
    #        return L.latLng(latlng.lat, latlng.lon)
    #    }
    ##
    #  buildPopup: (data, marker) ->
    #    return data.tags.name || null
    #}).addTo(@props.mapContainer)
    #
    #testMap.on "layerremove", ->
    #  console.log "wew"

    window.wew = @state.clusterContainer

  componentWillUnmount: ->
    delete @state.clusterContainer
  render: ->
    children = @getChildrenWithProps
      mapContainer: @props.mapContainer
      clusterContainer: @state.clusterContainer
    #noscript error
    if (Array.isArray children)
      children
    else
      <div>
        {children}
      </div>

module.exports = PruneClusterLayer