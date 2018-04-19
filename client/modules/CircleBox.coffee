# super tiny circle collision box.
angle = (vectorA, vectorB)->
	Math.atan2(vectorB.y - vectorA.y, vectorB.x - vectorA.x)

length = (vector)->
	Math.hypot(vector.x, vector.y)

dist = (vectorA, vectorB)->
	Math.hypot(vectorB.x-vectorA.x, vectorB.y-vectorA.y)

clamp = (n,min,max)->
	Math.min(Math.max(n, min), max)

class Circle
	constructor: (opt)->
		@x = opt.x || (Math.random()-.5)*3
		@y = opt.y || (Math.random()-.5)*3
		@pull_strength = opt.pull_strength || 0.1
		@mass = opt.mass
		@slop_factor = 1
		@radius = opt.radius || 10
		@density = opt.density || 1
		@target =
			x: @x
			y: @y
			pull_strength: 0.3
			mass: 1
			radius: 4
		@seed = Math.random()
		@tick = opt.tick


class CircleBox
	constructor: (opt)->
		opt = opt || {}
		@width = opt.width || 1
		@height = opt.height || 1
		@circles = []
		@slop_start = opt.slop_start || 4
		@slop_factor = opt.slop_factor || 10
		@speed_constant = opt.speed_constant || 2.5
		@speed_diff_factor = 5
		@target=
			x: opt.cx || 0
			y: opt.cy || 0
			pull_strength: 1
			mass: 1
			radius: 4

	add: (circle)->
		@circles.push circle


	checkBounds: (e)->
		hw = @width/2
		hh = @height/2
		r = e.radius
		
		if e.x + r > hw
			e.x = hw - r
		else if e.x - r < -hw
			e.x = -hw + r
		
		if e.y + r > hh
			e.y = hh - r
		else if e.y - r < -hh
			e.y = -hh + r


	setTargets: (x,y)->
		for c in @circles
			c.target.x = x || c.target.x
			c.target.y = y || c.target.y
	

	pull: (e,pos)->
		a = angle(pos,e)
		d = dist(e,pos)
		r = e.radius
		f = d/(r)
		mag = f * ( 0.2+@speed_constant / (1+e.mass/@speed_diff_factor) ) * e.pull_strength
		e.x -= Math.cos(a) * mag 
		e.y -= Math.sin(a) * mag


	collide: (e1,e2)->

		d = dist(e1,e2)
		r = e1.radius + e2.radius
		if d < r*0.25
			d = r*0.25
		a = angle(e1,e2)
		slop = (@slop_start+(@slop_factor/e1.mass))-(e1.density/e2.density)*(@slop_factor/e1.mass)
		a += e1.seed*0.00001
		if slop < 1
			slop = 1
		m = Math.log((r/2.7)/d)*slop+slop
		if m <= 0
			return
		m *= e1.slop_factor
		e1.x -= Math.cos(a) * m
		e1.y -= Math.sin(a) * m


	tick: =>
		for e in @circles
			if e.static
				continue
			@pull(e.target,@target)
			@pull(e,e.target)

		for e1 in @circles
			if e1.static
				continue
			for e2 in @circles
				if e1 != e2
					@collide(e1,e2)
		
		for e in @circles
			@checkBounds(e)
			e.tick(e.x,e.y,e.radius)

module.exports = {CircleBox,Circle}