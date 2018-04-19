


passport = require 'passport'
fs = require 'fs'
path = require 'path'
exp = require 'express'
require 'colors'
app = exp()



if ENV == 'dev'
	app.use '/public/',exp.static('public')



app.use (req,res,next)->
	next()


auth = require('./auth.coffee')
app.use('/auth',auth)


api = require('./api.coffee')
app.use('/api',api)
	


app.get '*',(req,res)->
	res.status(404).send 'not found'


app.use (err, req, res, next)->
	if ENV == 'dev'
		console.error err
	res.status(500).send err.message

server.listen process.env.WAVE_PORT, ()->
	log 'ENV',ENV.yellow
	log 'PORT',WAVE_PORT.yellow





