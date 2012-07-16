#Portastic

Programmatically find open ports with Node.js

#### Installation

To install Portastic you can simply use NPM:

    npm install portastic

#### Usage

Finding all opened doors within a range:

    port = require('portastic');

    options = {
    	min : 8000,
    	max : 8005
    }

    port.find(options, function(err, data){
    	if(err)
    		throw err;
    	console.log(data);
    });

If you wan't to retrieve just one or more doors you can pass it in the options:

	options = {
		min : 8000,
		max : 8005,
		retrieve : 1
	}

You can also test ports:

    port.test(80, function(err, data){
    	if(err)
    		throw err;

    	if(data == false)
    		console.log('The port isn\'t opened.');
    	else
    		console.log('The port is opened!');
    });

If you wan't to test an array of door, you sure can:

    port.test([80, 93, 8001, 22], function(err, data){
    	if(err)
    		throw err;

    	// 'data' will be an array with the opened doors only
    	console.log('Opened doors:', data);
    });

#### Command line

You can use Portastic in the command line too:

    npm install -g portastic

This will install portastic globally, now it's up to you to call it. Display the help with:

    portastic -h

#### Tests

If you wan't to run tests on portastic locally you will need to follow this steps:

    cd /path/to/portastic/folder
    npm install vows
    npm test

