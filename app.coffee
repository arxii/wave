global.log = console.log.bind(console)
global.ENV = process.env.ENV

require './server/main.coffee'