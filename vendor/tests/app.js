'use strict';
// This file create a small node server so 
// you view the files over http://localhost:3009/
// enter in commandline - $ node app
// Glenn Jones


var Hapi            = require('hapi'),
    Blipp           = require('blipp'),
    Pack            = require('./package');
    
    
var routes = [{
	method: 'GET',
	path: '/{path*}',
	handler: {
		directory: {
			path: '/tests',
			listing: true,
			index: false
		}
	}
},{
	method: 'GET',
	path: '/css/{path*}',
	handler: {
		directory: {
			path: './css',
			listing: true,
			index: true
		}
	}
},{
	method: 'GET',
	path: '/javascript/{path*}',
	handler: {
		directory: {
			path: './javascript',
			listing: true,
			index: true
		}
	}
}];    
    


// Create a server with a host and port
var server = new Hapi.Server();

server.connection({ 
    host: (process.env.PORT)? '0.0.0.0' : 'localhost', 
    port: parseInt(process.env.PORT, 10) || 3008
});


// hapi server settings
server.route(routes);


var goodOptions = {
    opsInterval: 1000,
    reporters: [{
        reporter: require('good-console'),
        events: { log: '*', response: '*' }
    }]
};



// Register plug-in and start
server.register([{
    register: require('good'), 
    options: goodOptions
  },{
    register: require('blipp'), 
  }], function (err) {
      if (err) {
          console.error(err);
      }else {
          server.start(function () {
              console.info('Server started at ' + server.info.uri);
          });
      }
  });
