'use strict';

var electron = require('electron');
var app = electron.app;

console.log("app.isReady()=" + app.isReady());

console.log("process.pid=" + process.pid);
console.log("process.platform=" + process.platform);
// execPath
console.log("process.execPath=" + process.execPath);
console.log("process.isMainFrame=" + process.isMainFrame);
console.log("process.sandboxed=" + process.sandboxed);
console.log("process.type=" + process.type);
console.log("process.getCPUUsage()=" + JSON.stringify(process.getCPUUsage()));
console.log("process.getHeapStatistics()=" + JSON.stringify(process.getHeapStatistics()));
//console.log("process.getProcessMemoryInfo()=" + JSON.stringify(process.getProcessMemoryInfo()));
console.log("process.versions=" + JSON.stringify(process.versions));

app.quit();