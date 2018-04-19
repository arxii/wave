{h,Component} = require 'preact'


# class to handle the app state of an item and update it whenever the app state updates
class StateItem extends Component
	stateHandleKey: ->
		undefined
	stateHandleRef: ->
		undefined
	componentWillMount: ->
		@_handle = @stateHandleRef()
		@_key = @stateHandleKey()
		if @_handle && @_key
			@_handle.bind(@_upd,@_key)
	componentWillUnmount: ->
		if @_handle && @_key
			@_handle.unbind(@_upd,@_key)
	_upd: =>
		if @stateHandleUpdate
			@stateHandleUpdate()
		else
			@forceUpdate()

module.exports = StateItem