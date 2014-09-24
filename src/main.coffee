app           = require 'app'
BrowserWindow = require 'browser-window'

require('crash-reporter').start();

# Keep a global reference of the window object, if you don't, the window will
# be closed automatically when the javascript object is GCed.
mainWindow = null;

app.on 'window-all-closed', ->
  app.quit() if process.platform != 'darwin'

app.on 'ready', ->
  mainWindow = new BrowserWindow width: 1200, height: 600
  mainWindow.loadUrl "file://#{ __dirname }/../index.html"

  mainWindow.on 'closed', ->
    mainWindow = null
