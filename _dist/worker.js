var test = require('./test.js');

console.log("wowza what's happing worker is worken!");
var testloop=1;
setInterval(function(){ 
    console.log("running test.js " + testloop++);
    test.renderPage();

    }, 6000);