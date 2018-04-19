{h} = require 'preact'
require './WormLoaderIcon.less'
class WormLoaderIcon
	render: (props)->
		h 'svg',
			className: '-ii-loader-worm '+(props.stop && '-ii-loader-worm-stop' || '')
			h 'rect',
				rx:6
				ry:6

module.exports = WormLoaderIcon