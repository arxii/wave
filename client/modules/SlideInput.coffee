require './SlideInput.less'
{Component,h} = require 'preact'
Slide = require 'preact-slide'
class SlideInput extends Component
	constructor: (props)->
		super(props)
		@state = 
			active: false
			focus: false
			text: ''

	componentDidUpdate: ->
		if @state.active && !@state.focus
			@_input.focus()
			@state.focus = true

	inputFieldRef: (el)=>
		@_input = el

	# onClick: =>
	# 	if !@state.active
	# 		@setState
	# 			active: yes

	onMouseEnter: =>
		@setState
			focus: yes
	onMouseLeave: =>
		@setState
			focus: no
	
	onBlur: =>
		@setState
			# active: no
			focus: no

	render: ->
		h Slide,
			vert: yes
			# onClick: @onClick
			onMouseEnter: @onMouseEnter
			onMouseLeave: @onMouseLeave
			className: '-ii-input-slide '+ @props.className
			slide: yes
			pos: @state.focus && 1 || 0
			h Slide,
				className: '-ii-input-slide-overlay'
				@props.label
			h Slide,
				className: '-ii-input-slide-main'
				h 'input',
					onBlur: @onBlur
					className: '-ii-input-slide-field'
					ref: @inputFieldRef
					placeholder: @props.label
					onInput: @props.onInput

module.exports = SlideInput