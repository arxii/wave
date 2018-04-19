class Ticker
	constructor:->
		@_arr = []
		@time = 0
	add: (fn)->
		@_arr.push fn
	remove: (fn)->
		i = @_arr.indexOf(fn)
		i != -1 && @_arr.splice i,1
	tick: (t)=>
		@time = t
		requestAnimationFrame(@tick)
		for cb in @_arr
			cb()

module.exports = Ticker