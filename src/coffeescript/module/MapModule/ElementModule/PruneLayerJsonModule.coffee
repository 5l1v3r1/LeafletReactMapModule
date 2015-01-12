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
    request.open('GET', url);
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
    for idx, cachedmarker in @_markersCache
      if cachedmarker
        marker_pos =  L.latLng(marker.position.lat, marker.position.lng)
        if bounds.contain marker_pos
          @props.clusterContainer.RegisterMarker(cachedmarker);
        else
          @props.clusterContainer.RemoveMarkers(cachedmarker);
    @props.clusterContainer.ProcessView();
    

  ###*    
  * 
  *  for(var k in json)
  *    that.addMarker.call(that, json[k]);
  *
  ### 
  _update: ->
    prec = 6
    bb = @props.mapContainer.getBounds()
    sw = bb.getSouthWest()
    ne = bb.getNorthEast()
    
    bbox = [
      [ parseFloat(sw.lat.toFixed(prec)), parseFloat(sw.lng.toFixed(prec)) ],
      [ parseFloat(ne.lat.toFixed(prec)), parseFloat(ne.lng.toFixed(prec)) ]
    ]

    _hashUrl = "http://overpass-api.de/api/interpreter?data=[out:json];node({lat1},{lon1},{lat2},{lon2})[amenity=bar];out;'"

    hashed_url = L.Util.template _hashUrl,  #  use hased url to obtain json data
       lat1: bbox[0][0], lon1: bbox[0][1]   #  then use the data returned to add marker
       lat2: bbox[1][0], lon2: bbox[1][1]   # 

    #ajax request here


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


  _onMove: ->
    #newZoom = @props.mapContainer.getZoom()
    #newCenter = @props.mapContainer.getCenter()
    newBounds = @props.mapContainer.getBounds()
    if @_maxBounds.contains(newBounds) == false
      console.log "update cache"
      @_update()

    @_maxBounds.extend(newBounds)
    

  #getInitialState: ->
  #  layerContainer: @_createLayer()
  componentWillMount: ->
  componentDidMount: ->
    @props.mapContainer.on "moveend", @_onMove
    @_center = @props.mapContainer.getCenter()
    @_maxBounds = @props.mapContainer.getBounds()
    window.prunetest = @
  componentWillUnmount: ->
    console.log "destroy layer"
    @props.mapContainer.removeLayer @state.layerContainer
      
  render: ->
    null

module.exports = PruneLayerJSON