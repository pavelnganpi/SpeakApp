//http://api.espn.com/:version/:resource/:method?apikey=:yourkey

var gapi = require('googleapis');

gapi.discover('youtube', 'v3');


var port = 4000;
var app = require('http').createServer(handler);
var io = require('socket.io').listen(app);

console.log("Listening on port " + port);
app.listen(port);


function handler (req, res) {
	fs.readFile(__dirname + '/index.html',
			function (err, data) {
			if (err) {
			res.writeHead(500);
			return res.end('Error loading index.html');
			}

			res.writeHead(200);
			res.end(data);
			});
}



io.sockets.on('connection', function (socket) {
		socket.emit('log', {foo:'hello'});
		// when the client emits 'sendchat', this listens and executes
		socket.on('message', function (data) {
	
		console.log("this is the data object we are returning " + data); 	
		switch (data.intent) {
			case "play_youtube": 
				search(data.query);
			break;
			case "stop": 
				io.sockets.emit('pause');	
			default: -1; 	
		}	
		});
		 

		socket.on('disconnect', function(){
		});




		function search(q) {
			console.log('i am in fucniton!'); 
			//var q = ('hello');
			gapi.execute(function(err, client){
					var req = client.youtube.search.list({
q: q,
part: 'snippet',
key: 'AIzaSyDqj127qEB6Jt7-fzoZwUxC1YnU0aURKgQ'
})
					req.execute(function(err, response) {

						//console.log(response)
						io.sockets.emit('update', response.items[0].id.videoId); 
						})
					})
};




});











/*
   var app = require('http').createServer(handler)
   , io = require('socket.io');

   var socket = io.listen(app)
   var  fs = require('fs')

   app.listen(3000);

   function handler (req, res) {
   fs.readFile(__dirname + '/index.html',
   function (err, data) {
   if (err) {
   res.writeHead(500);
   return res.end('Error loading index.html');
   }

   res.writeHead(200);
   res.end(data);
   });
   }

   socket.sockets.on('connection', function (client) {
   console.log("Client connects: " + client.id);
   client.on('message', function (data) {
// 		console.log(data);
//		obj  = JSON.parse(data);
console.log( "this is the intent " + data.intent);  //data.entities);
//console.log (data.entities);
var version 	 
switch (data.intent) {
case "athlete": 
var athele
break; 
case "teams":

break; 
case "stadium":


break; 
case "division": 

break;
case "sports_news":  

break;   
default: -1; 
} 
}

socket.sockets.emit("chat", 5);

);


});*/
