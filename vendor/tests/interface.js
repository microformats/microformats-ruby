
'use strict';
// This file allows node apps to get the current 
// test suite version number programmicatlly 
// Glenn Jones


if(require.main === module) { 
	// if they want the app
    var app = require('app.js');
}else{ 
	// if they want a module interface
	var pack = require('./package.json');

	module.exports = {
		'version': pack.version
	}
}