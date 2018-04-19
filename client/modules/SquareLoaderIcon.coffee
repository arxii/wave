{h} = require 'preact'
require './SquareLoaderIcon.less'
class SquareLoaderIcon
	render: (props)->
		h 'div',
			style:
				background: props.background
			className: '-ii-loader '+(props.stop && '-ii-loader-stop' || '') + ' '+props.className

module.exports = SquareLoaderIcon