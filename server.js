"use strict";

var http, fs, io, port, actions, server;

// Dependencies
http = require('http');
fs = require('fs');
io = require('socket.io');

// Initialization
port = process.env.PORT || 8080;
actions = [];

// Server logic
server = http.createServer(function (request, response) {
  // Server file system files
  fs.readFile('./public/index.html', function (error, data) {
    if (error) {
      throw 'Error loading index.html';
    }
    response.writeHead(200, {'Content-Type': 'text/html'});
    response.end(data);
  });
}).listen(port);

// Socket logic
io(server).on('connection', function (socket) {
  // Replay draw history
  actions.forEach(function (action) {
    socket.emit('line', action);
  });
  // Handle line events
  socket.on('line', function (data) {
    actions.push(data);
    socket.broadcast.emit('line', data);
  });
  // Handle clear events
  socket.on('clear', function (data) {
    actions = [];
    socket.broadcast.emit('clear', data);
  });
});
