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
  
  #contain cached marker
  _markersCache: {}

  ####*
  # * [_createLayer description]
  # * @return {[type]} [description]
  ####
  #_createLayer: ->
  #  layer.addTo @props.mapContainer
  #  return layer

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
            #console.log "-------- loaded layer from cache --------"
            #console.log cachedmarker.marker.data.name
            @props.clusterContainer.RegisterMarker(cachedmarker.marker)
            cachedmarker.loaded = true
        else
          if cachedmarker.loaded == true
            #console.log "-------- removed hidden marker --------"
            #console.log cachedmarker.marker.data.name
            @props.clusterContainer.RemoveMarkers([cachedmarker.marker])
            cachedmarker.loaded = false
            ##console.log  cachedmarker.marker
            #@props.clusterContainer.ProcessView();
    @props.clusterContainer.ProcessView()
    

  ###*
   * [_updateMarkerFromBounds description]
   * @return {[type]} [description]
  ###
  _updateMarkerFromBounds: (bounds) ->
    #console.log "update called"
    
    # current map bound

    prec = 6 #precision
    bb = bounds
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
    #console.log "ajax, #{hashed_url}"
    
    console.log bbox
    @_getAjax hashed_url, (data) =>
      #console.log "received: #{data.elements.length}"
      
      #define rectangle geographical bounds
      #bounds = [[54.559322, -5.767822], [56.1210604, -3.021240]];

      #create an orange rectangle
      #if window.debug? && window.debug == true
      #  bb = @props.mapContainer.getBounds()

      #  sw = bb.getSouthWest()
      #  ne = bb.getNorthEast()
      # 
      #  half_lat = (sw.lat.toFixed(prec) - ne.lat.toFixed(prec)) / 2
      #  half_lon = (sw.lng.toFixed(prec) - ne.lng.toFixed(prec)) /2

      #  sw2 = L.latLng(parseFloat(sw.lat.toFixed(prec)), parseFloat(sw.lng.toFixed(prec)))
      #  ne2 = L.latLng(parseFloat(ne.lat.toFixed(prec)), parseFloat(sw.lng.toFixed(prec))+half_lon)
      #  
      #  bounds = L.latLngBounds(sw, ne2)
      #  L.rectangle(bounds, {color: "#ff7800", weight: 1}).addTo(@props.mapContainer);

      # iterate new data returned from server
      # and check if they already loaded to cache
      # then register new marker to Prunecluster
      for element in data.elements
        hash = @_getPath(element, "id")
        if typeof @_markersCache[hash] == 'undefined'
          #console.log "save to cache: #{element.lat} #{element.lon} #{element.tags.name}"
          marker = new PruneCluster.Marker(element.lat, element.lon)
          marker.data.name = element.tags.name
          @props.clusterContainer.RegisterMarker marker

          @_markersCache[hash] =
            marker: marker
            loaded: true
      
      @props.clusterContainer.ProcessView()
          

  ###*
   * On Map moved check for bound coverage
   * if out of coverage get data
  ###
  _onMove: ->
    newBounds = @props.mapContainer.getBounds() 
    #if bound already cached lets load marker from cache
    if @_maxBounds.contains(newBounds) == true
      console.log "cached.."
      @_markersCacheToLayer()
      return false
    else
      console.log "update.."
      @_updateMarkerFromBounds(newBounds)
      @_maxBounds.extend(newBounds)

  componentWillMount: ->
  componentDidMount: ->
    #console.log "did mount"
    @props.mapContainer.on "moveend", @_onMove
    @_maxBounds = @props.mapContainer.getBounds() #set initial map bounds
    @_updateMarkerFromBounds(@_maxBounds) #get marker from current bounds

    window.prunetest = @
  componentWillUnmount: ->
    #console.log "destroy layer"
    @props.mapContainer.removeLayer @state.layerContainer
      
  render: ->
    null

module.exports = PruneLayerJSON