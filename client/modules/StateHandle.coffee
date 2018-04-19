{h,render} = require 'preact'
# class to handle the app state.
class StateHandle
	constructor: (props)->
		@view = props.view
		@state = {}
		@_binds = []
	
	setState: (state)=>
		if !state
			return @render()
		@state = Object.assign({},@state,state)
		for bind in @_binds
			if !bind.key? || state[bind.key]
				bind()
		@render(@state)

	bind: (fn,key)->
		fn.key = key
		@_binds.push fn

	unbind: (fn)->
		@_binds.splice @_binds.indexOf(fn),1

	render: =>
		@_el = render(h(@view,@state),document.body,@_el)

module.exports = StateHandle