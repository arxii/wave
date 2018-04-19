Slide = require 'preact-slide'
{Component,h} = require 'preact'
class SlideButton
	render: (props)->
		if !props.icon
			throw new Error 'SlideIcon missing icon prop'
		p = 
			ratio: 1
			center: yes	
		props = Object.assign p,props
		props.className = ('icon '+(props.className||''))+ ' i-font-'+props.icon
		props.ref = @setRef

		props = 
		h Slide,
			{...optionsDefault, ...options}
			props.childA
			props.childB

			

module.exports = SlideButton