'use strict';

var externalCallback;
var electron = require('electron');
var proc = require('child_process');
var filename = 'testpdfprint.pdf';
var child;
var sandbox=''; //'--no-sandbox';
var exec = require('child_process').exec;

console.log("running test.js from command line, does this even wrok:?");
	//exec('ps -ef', function(err, stdout, stderr) {
	  // stdout is a string containing the output of the command.
	//  console.log("=====   BEFORE stdout="+stdout);
	//});

  var spawnElectron = function () {
    console.log("spawnElectron spawn spahhhh")
    //Start electron child process.  Pass in config as string and open IPC channel for sending messages
    child = proc.spawn(
        electron,
        ['--no-sandbox', 'main.js', filename],
            //JSON.stringify(config)],  THIS WILL SEND THE CONFIG ON START.  BUT THERE IS A SIZE LIMIT AND THIS FAILS
            //WITH LARGE DATA SETS
            { stdio: [null, null, null, 'ipc']}
     );

    console.log("=====   main.js stdout after before ps 2 function =============== \n");

    exec('ps -ef', function(err, stdout, stderr) {
      // stdout is a string containing the output of the command.
      console.log("AFTER stdout="+stdout);
    });
  }

  module.exports = {
    renderPage: function renderPage () {
        console.log("Rendering page test.renderPage() .... woopie");
        return spawnElectron();
        console.log("AFTER spawnElectron()");
    }
};