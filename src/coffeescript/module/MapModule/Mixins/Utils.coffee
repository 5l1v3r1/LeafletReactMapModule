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
    React.Children.map @props.children, (child) ->
      React.addons.cloneWithProps(child, props)