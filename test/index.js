var assert = require("assert");
var expect = require("chai").expect;
var http = require('http');
var record = require('./record');
var config = require('config');

var koop_host = process.env.TEST_KOOP_HOST || '127.0.0.1'
var koop_port = config.server.port
var koop_agol_version = process.env.TEST_KOOP_AGOL_VERSION || '1.3.5';

describe('koopAgol', function () {
  var recorder = record('koopAgol');
  // Start recording http requests
  before(recorder.before);

  it('should return version from /status', function (done) {
    var parsed = '';
    var body = '';
    url = 'http://' + koop_host + ':' + koop_port + '/status'
    http.get(url, function(resp){
      resp.setEncoding('utf8');
      resp.on('data', function(chunk){
        body += chunk;
      });

      resp.on('end', function() {
        var parsed = JSON.parse(body);
        expect(parsed.providers.agol.version).to.equal(koop_agol_version);
        done();
      });
    }).on("error", function(e){
      console.log("Got error: " + e.message);
    });
  });

  it('should return true from /agol', function (done) {
    this.timeout(10000);
    var post_data = 'id=arcgis&host=https://www.arcgis.com'
    var post_options = { 
      host: koop_host,
      port: koop_port,
      path: '/agol',
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': post_data.length
      }
    };
    var parsed = '';
    var body = '';
    var post_req = http.request(post_options, function(resp){
      resp.setEncoding('utf8');
      resp.on('data', function(chunk){
        body += chunk;
      });

      resp.on('end', function() {
        var parsed = JSON.parse(body);
        expect(parsed.serviceId).to.equal(true);
        done();
      });
    }).on("error", function(e){
      console.log("Got error: " + e.message);
    });
    post_req.write(post_data);
    post_req.end();
  });

  it('should return a json item from /agol/:server_id/:item_id', function (done) {
    this.timeout(10000);
    var parsed = '';
    var body = '';
    url = 'http://' + koop_host + ':' + koop_port + '/agol/arcgis/1a8ababeed04496cb8b273948d60409e'
    http.get(url, function(resp){
      resp.setEncoding('utf8');
      resp.on('data', function(chunk){
        body += chunk;
      });

      resp.on('end', function() {
        var parsed = JSON.parse(body);
        expect(parsed.created).to.equal(1348512352000);
        done();
      });
    }).on("error", function(e){
      console.log("Got error: " + e.message);
    });
  });

  // Save all http responses as nock test fixtures for furture test runs.
  // Passing NOCK_RECORD=1 will recreate the fixtures from real http requests.
  after(recorder.after);
});
