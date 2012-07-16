# ***Portastic port finder.***
# Find opened ports with easy.
#
# @author Alan Hoffmeister <alan@cranic.com.br>
# @copyright Cranic Tecnologia e Informátics LTDA
# @date 2012-07-16
# @version 0.0.1

async = require 'async'
net = require 'net'

# Main portastic class
class Portastic

	# Public method find()
	# This method is resposable for retrieving all ports opened within the
	# passed port ranged, you can retrieve just one port by providing 
	# "retrieve : 4" in the options.
	#
	# @options, object. An object containing the options params.
	# Example:
	# 
	#    options =
	#      min : 8000
	#      max : 8020
	#      retrieve : 4
	#
	# @callbacl, function. A function to be executed when the method ends.
	find : (options, callback) ->
		process.nextTick ->

			# We need to validate what was passed to us
			errors = validate 'find', options, callback

			if errors instanceof Error
				#Inform the system if there was some error
				if typeof options == 'function'
					options errors, null
				else
					callback errors, null
			else
				arr = [options.min..options.max]
				async.filterSeries arr, check, (data) ->
					if options.retrieve == 1
						callback null, data.shift()
					else if options.retrieve
						callback null, data.slice 0, options.retrieve
					else
						callback null, data

	# Public method test()
	#
	# @port, integer. An integer representing the port to be tested
	# @callback, function. A function to be executed when the method ends.
	test : (port, callback) ->
		process.nextTick ->

			# We need to validate what was passed to us
			errors = validate 'test', port, callback
			if errors instanceof Error

				# Inform the system if there was some error
				if typeof port == 'function'
					port errors, null
				else
					callback errors, null
			else
				if port instanceof Array
					async.filterSeries port, check, (data) ->
						callback null, data
				else
					check port, (res) ->
						callback null, res

	# Private method check()
	# This method actually checks por the given port and return true
	# on opened or false if not.
	#
	# @port, integer. The port to be checked.
	# @callback, function. The function to be called when we got the results.
	check = (port, callback) ->
		process.nextTick ->
			tester = net.createServer()
			tester.on 'error', ->
				callback false
			tester.on 'listening', ->
				tester.close ->
					callback true
			tester.listen port

	# Private method validate()
	# Validate the user inputs for the other methods
	#
	# @method, string. A string representing the method to be validated.
	# @input, mixed. The user inputs to be validated.
	# @callback, function. The callback that the user povided.
	validate = (method, input, callback) ->
		if method == 'find'
			if input == null or !input or typeof input == 'function'
				return err 'PRMISSING'
			else if typeof input != 'object'
				return err 'INVALIDOBJ'
			else if typeof input.min == 'undefined'
				return err 'MISSINGMINPORT'
			else if parseInt(input.min) != input.min
				return err 'INVALIDMINPORTINT'
			else if typeof input.max == 'undefined'
				return err 'MISSINGMAXPORT'
			else if parseInt(input.max) != input.max
				return err 'INVALIDMAXPORTINT'
			else if input.max <= input.min
				return err 'INVALIDPORTRANGE'
			else if typeof input.retrieve != 'undefined' and ((parseInt(input.retrieve) != input.retrieve) or input.retrieve < 1)
				return err 'RETRIEVEINVINT'

		else if method = 'test'
			if input instanceof Array and input.lenght < 1
				return err 'INVTESTARR'
			else if (input instanceof Array == false) and parseInt(input) != input
				return err 'INVALIDPORTINT'

		else
			return err 'unknown'

	# Private method err()
	# Provides the error constructing
	#
	# @code, string. The error code to be constructed.
	err = (code) ->
		code = code.toUpperCase()

		# The commom error codes provided by Portastic
		errorCodes =
			'PRMISSING' : 'You need to provide the options.'
			'INVALIDOBJ': 'You need to provide an object as options.'
			'MISSINGMINPORT' : 'You need to provide a minimum port.'
			'INVALIDMINPORTINT' : 'The minimum port should be an integer.'
			'MISSINGMAXPORT' : 'You need to provide a maximum port.'
			'INVALIDMAXPORTINT' : 'The maximum port should be an integer.'
			'INVALIDPORTRANGE' : 'You need to provide a valid port range.'
			'RETRIEVEINVINT' : 'The retrieve option should be an integer.'
			'INVALIDPORTINT' : 'You should inform an integer as the port.'
			'INVTESTARR' : 'You need to provide a valid array for testing.'

		if typeof errorCodes[code] == 'undefined'
			# We shoud provide an unknown error if the method
			# didn't find the error code.
			errInfo = new Error('Unknown error.')
			errInfo['errno'] = 'UNCAUGHTERROR'
		else
		    # Or provide the error itslef :)
			errInfo = new Error(errorCodes[code])
			errInfo['errno'] = code

		return errInfo


# Exporting portastic
module.exports = Portastic