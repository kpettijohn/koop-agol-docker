var express = require('express');
var cors = require('cors');
var config = require('config');
var koop = require('koop')(config);
var agol = require('koop-agol');
var pgCache = require('koop-pgcache');
var path = require('path');
var app = express();
var server;

var http = require('http');

koop.registerCache(pgCache);
koop.register(agol);

app.set('port', process.env.PORT || config.server.port || 9000);

app.use(cors());
app.use(koop);

app.get('/status', function (req, res) {
  res.json(koop.status);
});

app.get('/', function (req, res) {
  res.json(koop.status);
});

server = http.createServer(app);

server.listen(app.get('port'), function () {
  console.log('Koop server listening on port ' + app.get('port'));
})
