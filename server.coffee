# Process environment variables
port = process.env.PORT or 8080

# Dependencies
fs = require('fs')
http = require('http')
socketio = require('socket.io')

# Initialize server state
actions = []

# Initialize http server
httpServer = http.createServer (req, res) ->
  fs.readFile "./public/index.html",
    (err, data) ->
      if err
        res.writeHead 500
        return res.end 'Error loading index.html'
      res.writeHead 200
      res.end data
httpServer.listen port
console.log "Listening on port #{port}"

# Initialize socket server
socketServer = socketio.listen httpServer
socketServer.sockets.on 'connection', (socket) ->
  console.log "Client connected"
  # Pass new client draw history
  socket.emit 'draw', action for action in actions

  socket.on 'send', (data) ->
    # Add to draw history
    actions.push data
    # Clear draw history
    actions = [] if data.action is "clear"
    # Pass draw command to peers
    socket.broadcast.emit 'draw', data

  socket.on 'disconnect', ->
    console.log "Client disconnected"
