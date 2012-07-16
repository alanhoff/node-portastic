/*
	Portastic bootstrap for loading .coffee on the fly.

	@author Alan Hoffmeister <alan@cranic.com.br>
	@copyright Cranic Tecnologia e Informátics LTDA
	@version 0.0.1
	@date 2012-07-16
*/

coffee = require('coffee-script');
port = require(__dirname + '/lib/portastic');

module.exports = new port();