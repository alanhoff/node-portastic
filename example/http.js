/*
	Portastic http server example.

	@author Alan Hoffmeister <alan@cranic.com.br>
	@copyright Cranic Tecnologia e Informátics LTDA
	@version 0.0.1
	@date 2012-07-16
*/


var http = require('http');
var port = require('../app.js');
var options = {
	min : 8000,
	max : 8005,
	retrieve : 1
}

port.find(options, function(err, port){
	if(err)
		throw err;

	http.createServer(function (req, res) {
		res.writeHead(200, {'Content-Type': 'text/plain'});
		res.end('Hello World\n');
	}).listen(port, '127.0.0.1');
	console.log('Server running at http://127.0.0.1:' + port + '/');

});
