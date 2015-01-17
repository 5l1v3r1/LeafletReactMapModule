
Reflux = require 'reflux'
Actions = require '../actions/actions.coffee'

#
#  init: ->
#    console.log "MarkerStore init"
##
##
MarkerStore = Reflux.createStore
  _markersCache: {}
  _maxBounds: null

  init: ->
    console.log "MarkerStore.coffee"
    this.listenTo(Actions.getMarkerBound, @_getMarkerBounds)
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
  _markersCacheToLayer: (bounds) ->
    console.log "cache call"    
    #bounds = @props.mapContainer.getBounds()
    #console.log @_markersCache
    test = []
    for idx, cachedmarker of @_markersCache
      if cachedmarker
        marker_pos =  L.latLng(cachedmarker.lat, cachedmarker.lon)
        if bounds.contains marker_pos
          if cachedmarker.loaded == false
            #console.log "-------- loaded layer from cache --------"
            #console.log cachedmarker.marker.data.name
            #@props.clusterContainer.RegisterMarker(cachedmarker.marker)
            cachedmarker.loaded = true
        else
          if cachedmarker.loaded == true
            #console.log "-------- removed hidden marker --------"
            #console.log cachedmarker.marker.data.name
            #@props.clusterContainer.RemoveMarkers([cachedmarker.marker])
            cachedmarker.loaded = false
            ##console.log  cachedmarker.marker
            #@props.clusterContainer.ProcessView();
        test.push(cachedmarker)
    Actions.receivedMarkerData(test)
  ###*
   * [_updateMarkerFromBounds description]
   * @return {[type]} [description]
  ###
  _updateMarkerFromBounds: (bounds) ->
    console.log "ajax call"
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
    #console.log bbox
    test = []

    @_getAjax hashed_url, (data) =>
      for element in data.elements
        hash = @_getPath(element, "id")
        if typeof @_markersCache[hash] == 'undefined'
          #console.log "save to cache: #{element.lat} #{element.lon} #{element.tags.name}"
          marker =
            hash: hash
            lat: element.lat
            lon: element.lon
            loaded: true
            data:{
              name: element.tags.name
            }
          #new PruneCluster.Marker(element.lat, element.lon)
          #marker.data.name = element.tags.name
          #@props.clusterContainer.RegisterMarker marker
          @_markersCache[hash] = marker
          test.push marker

      Actions.receivedMarkerData(test)
      #@props.clusterContainer.ProcessView()

  ###*
   * On Map moved check for bound coverage
   * if out of coverage get data
  ###
  _getMarkerBounds: (bounds) ->

    if @_maxBounds? #if not an initial data
      console.log "not initial"
      #if bound already cached lets load marker from cache
      if @_maxBounds.contains(bounds) == true
        #console.log "cached.."
        @_markersCacheToLayer(bounds)
        return false
      else
        #console.log "update.."
        @_updateMarkerFromBounds(bounds)
        @_maxBounds.extend(bounds)
    else
      console.log "update initial data.."
      @_updateMarkerFromBounds(bounds)
      @_maxBounds = bounds





module.exports = MarkerStore