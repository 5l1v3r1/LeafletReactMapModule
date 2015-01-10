###*
 * Common Utility
###

module.exports =
  ###*
   * [getChildrenWithProps create new children with additional props]
   * @param  {[type]} props [additional props]
   * @return {[type]}       [children with props]
  ###
  getChildrenWithProps: (props) ->
    if  (Array.isArray @props.children)
      React.Children.map @props.children, (child) ->
        React.addons.cloneWithProps(child, props)
    else
      React.addons.cloneWithProps(@props.children, props)