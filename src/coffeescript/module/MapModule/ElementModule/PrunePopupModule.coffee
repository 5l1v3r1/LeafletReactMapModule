###*
 * PrunePopup Module for Leaflet
 * Manage the child element
 * parent: @props.markerContainer
###

Utils = require "../Mixins/Utils.coffee"


PrunePopup = React.createClass
  mixins : [Utils]
  render: ->
    children = @getChildrenWithProps
      mapContainer: @props.mapContainer
      clusterContainer: @props.clusterContainer
      popUp: true
    if (Array.isArray children)
      children
    else
      <div>
        {children}
      </div>


module.exports = PrunePopup