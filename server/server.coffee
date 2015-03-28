# Process command line arguments
port = parseInt(process.argv[2]) or 8080

# Dependencies
http = require('http')
socketio   = require('socket.io')
fs   = require('fs')

# Initialize server state
clients = []
actions = []

# Initialize http server
httpServer = http.createServer (req, res) ->
  fs.readFile "#{__dirname}/client/index.html",
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
  # Initialize new client connection
  clients.push socket
  # Pass new client draw history
  socket.emit 'draw', action for action in actions

  socket.on 'send', (data) ->
    # Add to draw history
    actions.push data
    # Clear draw history
    actions = [] if data.action is "clear"
    # Pass draw command to peers
    for client in clients
      client.emit 'draw', data

  socket.on 'disconnect', ->
    console.log "Client disconnected"
    # Remove client reference
    index = clients.indexOf socket
    clients[index..index] = []
