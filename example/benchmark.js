/*
	Portastic benchmark.

	@author Alan Hoffmeister <alan@cranic.com.br>
	@copyright Cranic Tecnologia e Informátics LTDA
	@version 0.0.1
	@date 2012-07-16
*/

port = require('../app.js');
util = require('util');
os = require('os');

options = {
	min : 5000,
	max : 15000,
}

var start = new Date().getTime();
port.find(options, function(err, data){
	var end = new Date().getTime();
	var total = end - start;
	var reporter = {
		'os' : os.platform() + ' ' + os.release() + ' ' + os.arch(),
		'cpu' : {
			'model' : os.cpus()[0].model,
			'cores' : os.cpus().length
		},
		'mem' : {
			'total' : os.totalmem(),
			'free' : os.freemem()
		},
		'portastic' : {
			'ports' : options.max - options.min,
			'available' : data.length,
			'time' : {
				'total' : (total / 1000).toFixed(4),
				'perport' : ((total / data.length) / 1000).toFixed(4)
			}
		}
	}

	console.log(util.inspect(reporter, false, null));
});