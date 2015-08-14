var bluebird = require('bluebird');
var debug = require('debug')('portastic:unit:helpers');
var net = require('net');

exports.startTcp = bluebird.method(function(arr, iface) {
  return bluebird.resolve([].concat(arr))
    .map(function(number) {
      var def = bluebird.defer();

      var server = net.createServer();
      debug('Starting TCP server at port %s', number);

      server.on('error', function(err) {
        def.reject(err);
      });

      server.on('close', function() {
        debug('Server TCP at port %s has stopped', number);
        def.resolve();
      });

      server.listen(number, iface, function(err) {
        if (err)
          def.reject(err);

        def.resolve(server);
      });

      return def.promise;
    });
});

exports.stopTcp = bluebird.method(function(arr) {
  return bluebird.resolve([].concat(arr))
    .each(function(server) {
      var def = bluebird.defer();
      server.close(def.callback);

      return def.promise;
    });

});

exports.autoClose = bluebird.method(function(ports, iface, promise) {
  if (!promise || typeof iface !== 'string') {
    promise = iface;
    iface = null;
  }

  debug('Starting autoclose helper on ports %j', ports);
  return exports.startTcp(ports, iface)
    .then(function(servers) {
      return bluebird.resolve()
        .then(promise)
        .then(function() {
          return exports.stopTcp(servers);
        });
    });

});

exports.captureEvents = function(emitter, arr) {
  var emit = emitter.emit;
  emitter.emit = function() {
    var args = [].slice.call(arguments);
    arr.push(args);
    emit.apply(emit, args);
  };
};
