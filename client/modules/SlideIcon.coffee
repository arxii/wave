Slide = require 'preact-slide'
{Component,h} = require 'preact'
class SlideIcon
	render: (props)->
		if !props.icon
			throw new Error 'SlideIcon missing icon prop'
		p = 
			ratio: !props.dim? &&  1 || null
			dim: props.dim
			center: yes	
		props = Object.assign p,props
		props.className = ('icon '+(props.className||''))+ ' icon-'+props.icon
		h Slide,props,props.children
			

module.exports = SlideIcon