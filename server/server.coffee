httpServer = (req, res) ->
  fs.readFile __dirname + '/client/index.html',
    (err, data) ->
      if err
        res.writeHead 500
        return res.end 'Error loading index.html'
      res.writeHead 200
      res.end data

http = (require 'http').createServer httpServer
io   = (require 'socket.io').listen http
fs   = (require 'fs')

ip = null
port = parseInt(process.argv[2]) or 8080
http.listen port, ip

clients = []
actions = []

# On socket connection
io.sockets.on 'connection',
  # Socket initialization
  (socket) ->
    socket.emit 'draw', action for action in actions
    clients.push socket
    # On socket send data
    socket.on 'send',
      # Data pass
      (data) ->
        actions.push data
        actions = [] if data.action is "clear"
        for client in clients
          client.emit 'draw', data
    socket.on 'disconnect',
      # Remove client reference
      () ->
        index = clients.indexOf socket
        clients[index..index] = []

console.log "Listening on port #{port}"
