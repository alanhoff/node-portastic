# Portastic test suite.
# Installation:
#
#    cd /path/to/portastic
#    npm install
#    npm install -g vows
#    npm link vows
#    npm test
#
# Everything should be ok :)
# For guaranted test results be sure that the ports between
# 8000 and 8030 are all free.
#
# @author Alan Hoffmeister <alan@cranic.com.br>
# @copyright Cranic Tecnologia e Informátics LTDA
# @date 2012-07-16
# @version 0.0.1

port = require '../app'
vows = require 'vows'
assert = require 'assert'
net = require 'net'
coffee = require 'coffee-script'

vows.describe('Portastic generals tests.').addBatch
	'Basic construction tests' : 

		topic : -> 
			port

		'Port should be an object' : (port) ->
			assert.ok typeof port == 'object'

		'Should have the find() function' : (err, data, lol) ->
			assert.ok typeof port.find == 'function'

		'Should have the test() function' : (err, data) ->
			assert.ok typeof port.test == 'function'

	'Testing find() with no options' :

		topic : -> 
			port.find @callback
			return

		'Should have an error' : (err, data) ->
			assert.ok err instanceof Error

		'Should be informing that you need to pass port range' : (err, data) ->
			assert.equal err.errno, 'PRMISSING'

		'Should have nothing on data' : (err, data) ->
			assert.ok data == null

	'Testing find() with invalid parameter @options' :

		topic : ->
			port.find 'Something that isn\'t an object', @callback
			return

		'Should have an error' : (err, data) ->
			assert.ok err instanceof Error

		'Should inform you that you need to pass an object' : (err, data) ->
			assert.equal err.errno, 'INVALIDOBJ'

		'Should have nothing on data' : (err, data) ->
			assert.ok data == null	

	'Testing find() with invalid parameter @options (minimum port)' :

		topic : ->
			options = new Object()
			port.find options, @callback
			return

		'Should have an error' : (err, data) ->
			assert.ok err instanceof Error

		'Should inform you that you need to pass the minimum port' : (err, data) ->
			assert.equal err.errno, 'MISSINGMINPORT'

		'Should have nothing on data' : (err, data) ->
			assert.ok data == null

	'Testing find() with invalid parameter @options (minimum port should be integer)' :

		topic : ->
			options = 
				min : 'Something that isn\'t an integer'

			port.find options, @callback
			return

		'Should have an error' : (err, data) ->
			assert.ok err instanceof Error

		'Should inform you that you need to pass an integer on the minimum port' : (err, data) ->
			assert.equal err.errno, 'INVALIDMINPORTINT'

		'Should have nothing on data' : (err, data) ->
			assert.ok data == null

	'Testing find() with invalid parameter @options (maximum port)' :

		topic : ->
			options = 
				min : 8000

			port.find options, @callback
			return

		'Should have an error' : (err, data) ->
			assert.ok err instanceof Error

		'Should inform you that you need to pass the maximum port' : (err, data) ->
			assert.equal err.errno, 'MISSINGMAXPORT'

		'Should have nothing on data' : (err, data) ->
			assert.ok data == null

	'Testing find() with invalid parameter @options (maximum port should be an integer)' :

		topic : ->
			options = 
				min : 8000
				max : 'Something that isn\'t an integer'

			port.find options, @callback
			return

		'Should have an error' : (err, data) ->
			assert.ok err instanceof Error

		'Should inform you that you need to pass an integer on the maximum port' : (err, data) ->
			assert.equal err.errno, 'INVALIDMAXPORTINT'

		'Should have nothing on data' : (err, data) ->
			assert.ok data == null	

	'Testing find() with invalid parameter @options (maximum should be > than minumum)' :

		topic : ->
			options = 
				min : 8000
				max : 7000

			port.find options, @callback
			return

		'Should have an error' : (err, data) ->
			assert.ok err instanceof Error

		'Should inform you that you need to pass an integer > than minimum on the maximum port' : (err, data) ->
			assert.equal err.errno, 'INVALIDPORTRANGE'

		'Should have nothing on data' : (err, data) ->
			assert.ok data == null

	'Testing find() with invalid parameter @options (\'retrieve\' should be an integer)' :

		topic : ->
			options = 
				min : 8000
				max : 8999
				retrieve : 'Something that isn\'t an integer'

			port.find options, @callback
			return

		'Should have an error' : (err, data) ->
			assert.ok err instanceof Error

		'Should inform you that you need to pass an integer on the retrieve option' : (err, data) ->
			assert.equal err.errno, 'RETRIEVEINVINT'

		'Should have nothing on data' : (err, data) ->
			assert.ok data == null

	'Testing find() to find only one opened door' :

		topic : ->
			options = 
				min : 8000
				max : 8010
				retrieve : 1

			port.find options, @callback
			return

		'Should have no errors' : (err, data) ->
			assert.equal err, null

		'Should have an integer on data' : (err, data) ->
			assert.ok typeof data == 'number'	

	'Testing find() to find more than one door' :

		topic : ->
			options = 
				min : 8010
				max : 8020
				retrieve : 3

			port.find options, @callback
			return

		'Should have no errors' : (err, data) ->
			assert.equal err, null

		'Should have an array with 3 elements on data' : (err, data) ->
			assert.ok data instanceof Array and data.length == 3

	'Find should not include used doors' :

		topic : ->
			that = this
			testfindcloseddoor = net.createServer().listen(8025);
			testfindcloseddoor.on 'listening', ->
				options = 
					min : 8024
					max : 8030
					retrieve : 2
				port.find options, (err, data) ->
					testfindcloseddoor.close ->
						that.callback err, data
			return

		'Should have no error' : (err, data) ->
			assert.equal err, null

		'Data should not contain port 8025' : (err, data) ->
			assert.equal data.indexOf(8025), -1

	'Testing test() with invalid @port' :

		topic : ->
			port.test 'This is not an integer or an array' , @callback
			return

		'Should have error' : (err, data) ->
			assert.ok err instanceof Error

		'Should be informing that you need to provide an integer' : (err, data) ->
			assert.equal err.errno, 'INVALIDPORTINT'

		'Should not have any data' : (err, data) ->
			assert.equal data, null

	'Testing test() with a valid opened door' :

		topic : ->
			port.test 8021 , @callback
			return

		'Should have no error' : (err, data) ->
			assert.equal err, null

		'Data should be true' : (err, data) ->
			assert.equal data, true	

	'Testing test() with a closed door' :

		topic : ->
			that = this
			testcloseddoor = net.createServer().listen(8022);
			testcloseddoor.on 'listening', ->
				port.test 8022 , (err, data) ->
					testcloseddoor.close ->
						that.callback err, data
			return

		'Should have no error' : (err, data) ->
			assert.equal err, null

		'Data should be false' : (err, data) ->
			assert.equal data, false	

	'Testing test() with an array of doors' :

		topic : ->
			port.test [8026, 8027, 8028, 8029, 8030], @callback
			return

		'Should have no error' : (err, data) ->
			assert.equal err, null

		'Data should be an array with 5 elements' : (err, data) ->
			assert.ok data instanceof Array and data.length == 5

.export module
