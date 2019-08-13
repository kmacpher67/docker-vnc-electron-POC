var electron = require('electron');
const fs = require('fs');
var app = electron.app;

console.log("electron.app isReady=" + app.isReady());

setTimeout(function(){ 
 if (app.isReady) {
  var win = new electron.BrowserWindow(
          {
              width: 1200,  //Current these settings are being overriden with win.maximize().  Just leaving them here for
              height: 1296 //reference
          });

      var d = new Date().getTime(); //'+d.toString()+'
      // and load the index.html of the app.
      //win.loadFile('index.html')
      win.loadURL('https://www.google.com');

      win.webContents.on('did-finish-load', () => {
            // Use default printing options
            console.log("did-finish-load ====");
            win.webContents.printToPDF({}, (error, data) => {
              if (error) throw error
              fs.writeFile('print'+d.toString()+'.pdf', data, (error) => {
                if (error) throw error
                console.log('Write PDF successfully.');
                setTimeout(function(){ app.quit(); },500);
              })
            });
      })
    }
  }, 100);
  

