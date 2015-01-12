###*
 * Marker Module for Leaflet
 * Props:
 *   @props.mapContainer = leaflet map parent
 *   @props.position     = latitude, longitude array
 *   TODO:
 *   tileUrl
 *   maxZoom
 *   attribution
 *   id
 * State:
 *   @state.markerContainer = leaflet marker instance
###

Utils = require "../Mixins/Utils.coffee"

PruneLayerJSON = React.createClass
  
  _markersCache: {}

  ###*
   * [_createLayer description]
   * @return {[type]} [description]
  ###
  _createLayer: ->
    layer.addTo @props.mapContainer
    return layer

  ###*
   * Make Ajax Call
   *
   * @param  {[string]}   url [url]
   * @param  {Function} cb  [callback]
   * @return {[object]}       [json data]
  ###
  _getAjax: (url, cb) ->
    if (window.XMLHttpRequest == undefined)
      window.XMLHttpRequest = ->
        try
          return new ActiveXObject("Microsoft.XMLHTTP.6.0")
        catch e1
          try
            return new ActiveXObject("Microsoft.XMLHTTP.3.0")
          catch e2
            throw new Error("XMLHttpRequest is not supported")
    
    request = new XMLHttpRequest()
    request.open('GET', url)
    request.onreadystatechange = ->
      response = {}
      if (request.readyState == 4 && request.status == 200)
        try
          if(window.JSON)
            response = JSON.parse(request.responseText)
          else
            response = eval("("+ request.responseText + ")")
        catch err
          console.info(err)
          response = {}
        cb(response)

    request.send()
    return request



  ###*
   * Combine Lat Lon and Title for hashing
   * return data with matching properties
   *
   * @param  data obj  [description]
   * @param  properties prop [description]
   * @return string      [description]
  ###
  _getPath: (obj, prop) ->
    parts = prop.split('.')
    last = parts.pop()
    len = parts.length
    cur = parts[0]
    i = 1
    if(len > 0)
      while((obj = obj[cur]) && i < len)
        cur = parts[i++]
    if(obj)
      return obj[last]
   
  ###*
   * Clear all marker that out of bound
   * and add new marker that inside the bound
   * then call process view to redraw the map
   *
   * @param  LeafletMapBounds bounds [new bound]
  ###
  _markersCacheToLayer: ->
    bounds = @props.mapContainer.getBounds()
    for idx, cachedmarker of @_markersCache
      if cachedmarker
        marker_pos =  L.latLng(cachedmarker.marker.position.lat, cachedmarker.marker.position.lng)
        if bounds.contains marker_pos
          if cachedmarker.loaded == false
            console.log "-------- loaded layer from cache --------"
            console.log cachedmarker.marker.data.name            
            @props.clusterContainer.RegisterMarker(cachedmarker.marker)
            cachedmarker.loaded = true            
        else
          if cachedmarker.loaded == true
            console.log "-------- removed hidden marker --------"
            console.log cachedmarker.marker.data.name
            @props.clusterContainer.RemoveMarkers([cachedmarker.marker])
            cachedmarker.loaded = false
            #console.log  cachedmarker.marker
            #@props.clusterContainer.ProcessView();          
    @props.clusterContainer.ProcessView();
    

  ###*
  *
  *  for(var k in json)
  *    that.addMarker.call(that, json[k]);
  *
  ###
  _update: ->
    console.log "update called"
    
    # current map bound 

    prec = 6 #precision
    bb = @props.mapContainer.getBounds()
    sw = bb.getSouthWest()
    ne = bb.getNorthEast()
    
    bbox = [
      [ parseFloat(sw.lat.toFixed(prec)), parseFloat(sw.lng.toFixed(prec)) ],
      [ parseFloat(ne.lat.toFixed(prec)), parseFloat(ne.lng.toFixed(prec)) ]
    ]

    # hashed url from map bound

    _hashUrl = "http://overpass-api.de/api/interpreter?data=[out:json];node({lat1},{lon1},{lat2},{lon2})[amenity=bar];out;"

    hashed_url = L.Util.template _hashUrl,  #  use hased url to obtain json data
       lat1: bbox[0][0], lon1: bbox[0][1]   #  then use the data returned to add marker
       lat2: bbox[1][0], lon2: bbox[1][1]   #

    #ajax request to hashed url
    #check whether data is cached, if not add the data to cache array
    console.log "ajax, #{hashed_url}"
    
    @_getAjax hashed_url, (data) =>  
      console.log "received: #{data.elements.length}"
      for element in data.elements
        hash = @_getPath(element, "id")
        if typeof @_markersCache[hash] == 'undefined'
          console.log "save to cache: #{element.lat} #{element.lon} #{element.tags.name}"
          marker = new PruneCluster.Marker(element.lat, element.lon)
          marker.data.name = element.tags.name
          @props.clusterContainer.RegisterMarker marker

          @_markersCache[hash] = 
            marker: marker 
            loaded: true
        @props.clusterContainer.ProcessView()
          


  _defaultDataToMarker: (lat, lng)->
    marker = new PruneCluster.Marker(lat, lng)
    @props.clusterContainer.RegisterMarker(marker)
    @props.clusterContainer.ProcessView()
    return marker

  ###*
   *  todo : hash
   *  check hash has content
   *   if not create marker and set hash to marker instance
   *
  ###
  _addMarker: (data) ->
    hash = "bogus"
    console.log "add marker"

    if @_markersCache[hash]?
      console.log "save cache"
      @_markersCache[hash] = @_dataToMarker(data, latlng)

    if @_markersCache[hash]?
      @props.clusterContainer.RegisterMarker @_markersCache[hash]

  ###*
   * On Map moved check for bound coverage
   * if out of coverage get data
  ###
  _onMove: ->
    #newZoom = @props.mapContainer.getZoom()
    #newCenter = @props.mapContainer.getCenter()  
    newBounds = @props.mapContainer.getBounds()
  
    if @_maxBounds.contains(newBounds) == true
      console.log "_markersCacheToLayer()"      
      @_markersCacheToLayer()
      return false
    else
      console.log "get update cache"
      @_update()
      @_maxBounds.extend(newBounds)

  #getInitialState: ->
  #  layerContainer: @_createLayer()
  componentWillMount: ->
  componentDidMount: ->
    @props.mapContainer.on "moveend", @_onMove

    @_center = @props.mapContainer.getCenter()
    @_maxBounds = @props.mapContainer.getBounds()

    @_update()
    #console.log @_center
    window.prunetest = @
  componentWillUnmount: ->
    console.log "destroy layer"
    @props.mapContainer.removeLayer @state.layerContainer
      
  render: ->
    null

module.exports = PruneLayerJSON