var app = require('http').createServer(handler)
  , io = require('socket.io').listen(app)
  , fs = require('fs')

app.listen(80, "10.80.0.186");

function handler (req, res) {
  fs.readFile(__dirname + '/../client/index.html',
  function (err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    }

    res.writeHead(200);
    res.end(data);
  });
}

io.set('log level', 1);
var clients = [];
var actions = [];

io.sockets.on('connection', function (socket) {
  for(i in actions){
    socket.emit('draw', actions[i]);
  }
  clients.push(socket);
  socket.on('send', function (data) {
    actions.push(data);
    if(data.action == "clear"){
      actions = [];
    }
    for(i in clients){
      clients[i].emit('draw', data);
    }
  });
});