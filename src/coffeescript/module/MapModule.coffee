Map = React.createClass
  initMap: ->
    map = L.map(this.getDOMNode()).setView([-0.789275,113.921327], 5)
    layer = L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png',
    {
      maxZoom: 13
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
        '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="http://mapbox.com">Mapbox</a>'
      id: 'examples.map-i875mjb7'
    })
    layer.addTo map
    @setState map: map
  componentDidMount: ->
    #@map = "wew"
    #@setProps map: map
    @initMap()
  getChildrenWithProps: (instance) ->
    React.Children.map @props.children, (child) ->
      React.addons.cloneWithProps(child, {mapContainer: instance.state.map})
  render: ->

    if not map?
      children = null
    else
      children = @getChildrenWithProps(@)

    <div id="map">
      {children}
    </div>


module.exports = Map