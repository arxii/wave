# threejs
window.log = console.log.bind(console)
window.THREE = require 'three'
window.DIM = 40
Slide = require 'preact-slide'
require './main.less'
{preact,h,Component} = require 'preact'
require 'three/examples/js/postprocessing/EffectComposer'
require 'three/examples/js/postprocessing/RenderPass'
require 'three/examples/js/postprocessing/ShaderPass'
require 'three/examples/js/shaders/CopyShader'
require 'three/examples/js/renderers/CSS3DRenderer'

StateHandle = require './modules/StateHandle.coffee'
randomColor = require 'random-color'

window.ploaded()
Math.clamp  = (v,min,max)->
	if v < min
		return min
	else if v > max
		return max
	else
		return v 
default_vs = require('./default_vs.glsl').default
t_shader = require('./shader.glsl').default
# log t_shader

# log randomColor()
# throw 'stop'

class Wave
	constructor: (opt)->
		@length = 100
		@width = 10
		@radius = 20
		@pitch = 0
		@angle_offset = 0
		
		@mat = new THREE.ShaderMaterial
			vertexShader: default_vs
			fragmentShader: t_shader
			uniforms:
				color: 
					type: 'v3'
					value: randomColor().rgbaArrayNormalized().splice(0,3)
				opacity:
					type: 'f'
					value: 1
				iTime: _time_unif
			flatShading: true
			transparent: true
		




		
		@linkedBuffer = opt.buffer
		@waveBuffer = new Float32Array(opt.buffer_length).fill(0.0)

	
		@size = opt.size || Math.PI
		@height = 40
		@wave_count = 3
		@wave_diff  = 0

		@fade_start = 0.2
		@fade_end = 0.2

		@createWedgeGeom()

	# buildPoint: (angle,r,buff)->
		
	createWedgeGeom: ->
		@verts = new Float32Array(@length*12).fill(0)
		@uvs = new Float32Array(@length*2).fill(0)
		@norms = new Float32Array(@length*3).fill(0)
		# indexes = []
		for i in [0...@length]
		
			start_angle = (Math.PI)/@length*(i-1)
			end_angle = (Math.PI)/@length*i
			inner_r = @radius
			outer_r = @radius+@width
			# @uvs[i*2+0] = 1/@length*i
			# x = Math.cos(a)*r
			# y = Math.sin(a)*r
			
			# if i % 2 == 0
			@verts[i*12+0] = Math.cos(start_angle)*inner_r
			@verts[i*12+1] = Math.sin(start_angle)*inner_r

			@verts[i*12+2] = Math.cos(start_angle)*outer_r
			@verts[i*12+3] = Math.sin(start_angle)*outer_r
			
			@verts[i*12+4] = Math.cos(end_angle)*outer_r
			@verts[i*12+5] = Math.sin(end_angle)*outer_r


			@verts[i*12+6] = Math.cos(start_angle)*inner_r
			@verts[i*12+7] = Math.sin(start_angle)*inner_r
			
			@verts[i*12+8] = Math.cos(end_angle)*outer_r
			@verts[i*12+9] = Math.sin(end_angle)*outer_r

			@verts[i*12+10] = Math.cos(end_angle)*inner_r
			@verts[i*12+11] = Math.sin(end_angle)*inner_r
			


		@geom = new THREE.BufferGeometry()
		@geom.setAttribute( 'position', new THREE.BufferAttribute( @verts, 2 ) )
		# @geom.setAttribute( 'uv', new THREE.BufferAttribute( @uvs, 2 ) )

		# @geom.setIndex(indexes)
		@mesh = new THREE.Mesh @geom,@mat
		# @mesh.drawMode = THREE.TriangleStripDrawMode



	fadeInOut: (beta)->
	
		#Math.sin(Math.sin(Math.sin(beta-Math.PI / (Math.PI * (1 / .1)*2)*Math.PI*1/ .1))) / 1.49124 + .5
		if beta < @fade_start
			return Math.cos(Math.cos(Math.sin(beta*1/@fade_start*Math.PI-Math.PI/2)/2+.5))*Math.PI-1.697
		else if beta > (1-@fade_end)
			return Math.cos(Math.cos(Math.sin((1-beta)*1/@fade_end*Math.PI-Math.PI/2)/2+.5))*Math.PI-1.697
		return 1
		

		

	tick: (waveBuffer)=>
		
		@geom.attributes.position.needsUpdate = true
		bufferLength = @waveBuffer.length

		@max_wave = -Infinity
		@min_wave = Infinity

		pitch_t = 0
		pitch_tc = 0
		pitch_c = 0
		@gain = 0
		prev_wave = 0
		
		
		for i in [0...@length]
			# current angle relative to center of wave
			# a = @size / @length * i



			
			
			beta1 = i / @length
			beta2 = (i+1) / @length
			buffer_i = Math.floor(bufferLength*beta1)
			buffer_i2 = Math.floor(bufferLength*beta2)
			
			vol = 0

			
		
		
			#sync wave with sound if buffer is passed into tick 
			if waveBuffer 
				@waveBuffer[buffer_i] = waveBuffer[buffer_i]
				@waveBuffer[buffer_i2] = waveBuffer[buffer_i2]
			
			# fade out
			else
				@waveBuffer[buffer_i] += (0.0 - @waveBuffer[buffer_i])*.1
				@waveBuffer[buffer_i2] += (0.0 - @waveBuffer[buffer_i2])*.1
			

			if @waveBuffer[buffer_i] > @max_wave
				@max_wave = @waveBuffer[buffer_i]
			

			if @waveBuffer[buffer_i] < @min_wave
				@min_wave = @waveBuffer[buffer_i]



			
			if (prev_wave > 0 && @waveBuffer[buffer_i] <= 0)
				pitch_tc += pitch_t
				pitch_c++
				pitch_t = 0


			if @waveBuffer[buffer_i] > 0
				pitch_t++




			prev_wave = @waveBuffer[buffer_i]


		
			r_offset = @waveBuffer[buffer_i]*20*@fadeInOut(beta1)
			r_offset2 = @waveBuffer[buffer_i2]*20*@fadeInOut(beta2)
			
			
			outer_r = (@radius+r_offset)
			outer_r2 = (@radius+r_offset2)

			

			# r -= 5/@length*i

			
			

			# px = Math.cos(a) * r
			# py = Math.sin(a) * r
			# fact = 0.2

			# if freq > 1
			# 	fact *= 2.0
			start_angle = (Math.PI)/@length*(i-1)
			end_angle = (Math.PI)/@length*i
			

			# log outer_r
			# if i%2 == 0
			@verts[i*12+2] = Math.cos(start_angle)*outer_r
			@verts[i*12+3] = Math.sin(start_angle)*outer_r
			@verts[i*12+4] = @verts[i*12+8] = Math.cos(end_angle)*outer_r2
			@verts[i*12+5] = @verts[i*12+9] = Math.sin(end_angle)*outer_r2

		# else
			# 	@verts[i*12+2] = Math.cos(start_angle)*outer_r
			# 	@verts[i*12+3] = Math.sin(start_angle)*outer_r
			# 	@verts[i*12+4] = @verts[i*12+8] = Math.cos(end_angle)*outer_r2
			# 	@verts[i*12+5] = @verts[i*12+9] = Math.sin(end_angle)*outer_r2

			


			
		@wave_diff = Math.clamp(@max_wave - @min_wave,0,2)
		
		@angle_offset += ((@pitch/@length) - @angle_offset)*.1#*@pitch/10
			
		# @mesh.rotation.z = Math.PI/2 - @angle_offset*2
		
		# @size += (Math.PI*1.5-@wave_diff*1.5 - @size) * .3
		@mat.uniforms.opacity.value = @wave_diff/2
		
		if pitch_tc != pitch_c != 0
			@pitch = pitch_tc / pitch_c


		




class AppView extends Component

	constructor: (props)->
		super(props)
		@state = {}
		@graph = props.graph
		@camera = new THREE.PerspectiveCamera(45,1,1,1000)
		@plane = new THREE.Mesh(new THREE.PlaneBufferGeometry(1000,1000))
		@plane.material.visible = false
		@camera.position.z = 200
		@textureLength = 64
		
		@bufferLength = Math.pow(2,11)
		@scene = new THREE.Scene()

		@circ = new THREE.Mesh(new THREE.CircleBufferGeometry(40,40),new THREE.MeshBasicMaterial(color:'#000'))
		@circ.position.z = 10
		# @scene.add @circ

		window.scene = @

	
		@time_unif = 
			value: 0
			type: 'f'
		window._time_unif = @time_unif
		
		
		@renderer = new THREE.WebGLRenderer
			antialias: no
			depth : yes
			alpha: no
			logarithmicDepthBuffer : no
			precision: "lowp"
		
		@raycaster = new THREE.Raycaster()
		@renderer.setClearColor( '#1c1f2b' )
		@renderer.setPixelRatio( window.devicePixelRatio )




		
	initAudio: ->
		@audio_ctx = new AudioContext()
		@audio_source = @audio_ctx.createMediaElementSource(@_track)
		@audio_source.channelCount = 1
		@audio_source.channelCountMode = 'explicit'


		@lowNode = @audio_ctx.createAnalyser()
		@midNode = @audio_ctx.createAnalyser()
		@highNode = @audio_ctx.createAnalyser()
		@freqNode = @audio_ctx.createAnalyser()



		@lowNode.fftSize = Math.pow(2,11)
		@midNode.fftSize = Math.pow(2,10)
		@highNode.fftSize = Math.pow(2,9)
		@freqNode.fftSize = Math.pow(2,5)
	
		
		@gainNode = @audio_ctx.createGain()
		@gainNode.gain.setValueAtTime(1,0)


		low_freq = 100
		high_freq = 200


		@lowFilterA = @audio_ctx.createBiquadFilter()
		@lowFilterA.type = "lowpass";
		@lowFilterA.frequency.setValueAtTime(100,0)
		# @lowFilterA.Q.setValueAtTime(3,0)

		@lowFilterB = @audio_ctx.createBiquadFilter()
		@lowFilterB.type = "lowpass";
		@lowFilterB.frequency.setValueAtTime(100,0)
		# @lowFilterB.Q.setValueAtTime(3,0)

		@lowFilterC = @audio_ctx.createBiquadFilter()
		@lowFilterC.type = "lowpass";
		@lowFilterC.frequency.setValueAtTime(100,0)
		# @lowFilterC.Q.setValueAtTime(3,0)


		


		@midFilterA = @audio_ctx.createBiquadFilter()
		@midFilterA.type = "lowpass";
		@midFilterA.frequency.setValueAtTime(300,0)

		@midFilterB = @audio_ctx.createBiquadFilter()
		@midFilterB.type = "lowpass";
		@midFilterB.frequency.setValueAtTime(300,0)

		@midFilterC = @audio_ctx.createBiquadFilter()
		@midFilterC.type = "lowpass";
		@midFilterC.frequency.setValueAtTime(300,0)




		@midFilterD = @audio_ctx.createBiquadFilter()
		@midFilterD.type = "highpass";
		@midFilterD.frequency.setValueAtTime(170,0)
		
		@midFilterE = @audio_ctx.createBiquadFilter()
		@midFilterE.type = "highpass";
		@midFilterE.frequency.setValueAtTime(170,0)

		@midFilterF = @audio_ctx.createBiquadFilter()
		@midFilterF.type = "highpass";
		@midFilterF.frequency.setValueAtTime(170,0)
		
		





		# high filter
		@highFilterA = @audio_ctx.createBiquadFilter()
		@highFilterA.type = "highpass";
		@highFilterA.frequency.setValueAtTime(400,0)
		# @highFilterA.Q.setValueAtTime(1,0)

		@highFilterB = @audio_ctx.createBiquadFilter()
		@highFilterB.type = "highpass";
		@highFilterB.frequency.setValueAtTime(400,0)
		# @highFilterB.Q.setValueAtTime(1,0)

		@highFilterC = @audio_ctx.createBiquadFilter()
		@highFilterC.type = "highpass";
		@highFilterC.frequency.setValueAtTime(400,0)
		# @highFilterC.Q.setValueAtTime(1,0)


		# high filter
		@highFilterD = @audio_ctx.createBiquadFilter()
		@highFilterD.type = "lowpass";
		@highFilterD.frequency.setValueAtTime(800,0)
		# @highFilterD.Q.setValueAtTime(1,0)

		@highFilterE = @audio_ctx.createBiquadFilter()
		@highFilterE.type = "lowpass";
		@highFilterE.frequency.setValueAtTime(800,0)
		# @highFilterB.Q.setValueAtTime(1,0)

		@highFilterF = @audio_ctx.createBiquadFilter()
		@highFilterF.type = "lowpass";
		@highFilterF.frequency.setValueAtTime(800,0)
		# @highFilterC.Q.setValueAtTime(1,0)




		# low filter connects
		@audio_source.connect(@lowFilterA)
		@lowFilterA.connect(@lowFilterB)
		@lowFilterB.connect(@lowFilterC)
		@lowFilterC.connect(@lowNode)

		

		#mid filter connects
		@audio_source.connect(@midFilterA)
		@midFilterA.connect(@midFilterB)
		@midFilterB.connect(@midFilterC)
		@midFilterC.connect(@midFilterD)
		@midFilterD.connect(@midFilterE)
		@midFilterE.connect(@midFilterF)
		@midFilterF.connect(@midNode)
		


		# high filter connects
		@audio_source.connect(@highFilterA)
		@highFilterA.connect(@highFilterB)
		@highFilterB.connect(@highFilterC)
		@highFilterC.connect(@highFilterD)
		@highFilterD.connect(@highFilterE)
		@highFilterE.connect(@highFilterF)
		@highFilterF.connect(@highNode)


		
		
		
		@audio_source.connect(@freqNode)
		# @audio_source.connect(@audio_ctx.destination)
		



		
		@lowBuffer = new Float32Array(Math.pow(2,11))
		@midBuffer = new Float32Array(Math.pow(2,10))
		@highBuffer = new Float32Array(Math.pow(2,9))
		


		@freqBuffer = new Uint8Array(@freqNode.frequencyBinCount)




		@waves = []
		l = 5
		for i in [0...l]
			wave = new Wave
				buffer_length: Math.pow(2,11)
				freq_length: @freqLength
				opacity: 1.0
			@scene.add wave.mesh
			@waves.push wave
		

		
			

		
		
		# @audio_source.connect(@audio_ctx.destination)
		


	componentDidMount:->
		# @_track.currentTime = 80
		@_track.play()
		window.addEventListener 'resize',@onResize
		@onResize()


	matchWave: (waves,waveBuffer)->
		# log waveBuffer.length
		matched_wave = null
		samples = 20
		wl = waveBuffer.length
		wave_diff = Infinity
		mi = 0
		for wave,i in waves
			dist = 0
			for j in [0...samples]
				sample_i = Math.floor(wl/samples*j)
				dist += Math.abs(wave.waveBuffer[sample_i] - waveBuffer[sample_i])

			if dist < wave_diff
				matched_wave = wave
				wave_diff = dist
				mi = i
	
		return matched_wave




	mapWaves: ()->
		
		matched_wave = @matchWave(@waves,@lowBuffer)

		for wave in @waves
			if wave == matched_wave
				wave.tick(@lowBuffer)
			else
				wave.tick()






	tick: (t)=>
		
		@highNode.getFloatTimeDomainData(@highBuffer)
		@midNode.getFloatTimeDomainData(@midBuffer)
		@lowNode.getFloatTimeDomainData(@lowBuffer)
		
		
		requestAnimationFrame @tick
		@mapWaves()

		
		@renderer.render(@scene,@camera)



	setRef: (el)=>
		@_el = el
		@_el.appendChild(@renderer.domElement)
		requestAnimationFrame @tick

	setTrackRef: (track)=>

		@_track = track
		@_track.currentTime = 0
		@initAudio()
		


	onResize: =>
		width = @_el.clientWidth
		height = @_el.clientHeight
		@width = width
		@height = height
		@camera.aspect = width/height
		@renderer.setViewport( 0, 0, width, height )
		@renderer.setSize(width,height)
		@camera.updateProjectionMatrix()

	render: ->
		h 'div',
			className: 'app'
			ref: @setRef
			h 'audio',
				ref: @setTrackRef
				style: 
					display: 'none'
				src: "bishop-river.mp3"





class Interface extends StateHandle
	constructor: (opt)->
		super(opt)
		@state = {}




window.face = new Interface
	view: AppView
				
face.render()