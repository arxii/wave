{h,Component} = require 'preact'
require './Overlay.less'
class Overlay extends Component
	constructor: (props)->
		super(props)
		@state=
			visible: props.visible
			render: props.visible

	componentWillUpdate: (props)->
		if @props.visible != props.visible
			if props.visible
				@state.render = true

	componentDidUpdate: (p_props,p_state)->
		if @state.visible != @props.visible
			setTimeout ()=>
				@setState
					visible: @props.visible
			,0
			

			if !@props.visible
				setTimeout ()=>
					@setState
						render: @props.visible
				,1000

	
	render: (props,state)->
		h 'div',
			onClick: props.onClick
			className: '-ii-overlay'+ (!@state.visible && ' -ii-overlay-hidden' || '') + (props.className && (" "+props.className)||'')
			style:
				display: !@state.render && 'none' || ''
				background: props.background
			@state.render && props.children || null

module.exports = Overlay