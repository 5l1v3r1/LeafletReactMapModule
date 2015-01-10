Test = React.createClass
  handleClick: ->
    #console.log "handle click"
    #@props.onClick()
    @setState
      count: @state.count+1
  getInitialState: ->
    count: 0
  componentWillUnmount: ->
    console.log "TEST UNMOUNT"
  render: ->
    <button onClick={@handleClick}>TEST {@state.count}</button>