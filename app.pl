#!/usr/bin/env perl

use strict;
use warnings;
use Dancer;

# this Dancer CORS test app is modeled after https://github.com/hidekiy/cors-cookie-test

get '/cors/test' => sub {
	return '
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=320">
	<title>cors-cookie-test-client</title>
</head>
<body>
	We will talk to one "other" server, localhost:3000, via xhr requests here.
	<br>Make sure this page is open on <a href="http://0.0.0.0:3000/cors/test">http://0.0.0.0:3000/cors/test</a>
	<br><small>(Background: we are taking advantage of the quirk here, that we should be able to communicate
	<br>with one Dancer instance via two different shorthands, localhost and 0.0.0.0)</small>
	<br>
	<br>
	<br>Log:
	<div id="log"></div>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script>

	/* if you think jquery is doing something wrong, uncomment this and compare
	var xhr = new XMLHttpRequest();

	xhr.open("GET", "http://localhost:3000/cors/get?test", true);
	xhr.withCredentials = true;
	// xhr.onreadystatechange = handler;
	xhr.send();

	$.ajax({
	  	url: "http://localhost:3000/cors/get?test2",
	  	dataType: "text",
	  	type: "GET",
	  	data: {},
		xhrFields: {
			withCredentials: true
		},
	//	beforeSend: function(xhr){
	//		xhr.withCredentials = true;
	//	},
	//	crossDomain : true,
	});
	*/

	var baseUrl = "http://localhost:3000/cors";
	$.ajax({
		url: baseUrl + "/get",
		success: function (data) {
			console.log("get ok: raw data:",data);
			data = JSON.parse(data);
			console.log("get ok: parsed data:",data);
			$("#log").append($("<p/>", {text: "get: " + JSON.stringify(data)}));

			var num;
			if (data && data.state) {
				num = Number(data.state);
				console.log(" has state:", num);
			} else {
				console.log(" init state: 1");
				num = 1;
			}

			$.ajax({
				method: "post",
				url: baseUrl + "/post",
				contentType: "application/json; charset=utf-8",
			//	contentType: "text/plain; charset=utf-8",
				success: function (data) {
					console.log("post ok: raw data:",data);
					data = JSON.parse(data);
					console.log("post ok: parsed data:",data);
					$("#log").append($("<p/>", {text: "post: " + JSON.stringify(data)}));
				},
				data: {
					state: num + 1
				},
				crossDomain : true,
				xhrFields: {
					withCredentials: true
				}
			});
		},
		crossDomain : true,
		xhrFields: {
			withCredentials: true
		}
	});
	</script>
</body>
</html>
	';
};

get '/cors/get' => sub {
	header('Access-Control-Allow-Origin'		=> 'http://0.0.0.0:3000');
	header('Access-Control-Allow-Credentials'	=> 'true');
#	header('Content-Type' => 'application/json');
  debug("GET: cookie is ".(cookie('state')||'nothing'));
	return to_json({ state => cookie('state') },{pretty => 0});	# is there a cookie from a previous round?
};

options '/cors/post' => sub {
	my @headers = split(/,\s+/, request->header('Access-Control-Request-Headers') ) if request->header('Access-Control-Request-Headers');

	header('Access-Control-Allow-Origin'	=> 'http://0.0.0.0:3000');
	header('Access-Control-Allow-Methods'	=> 'GET, POST, OPTIONS');
	header('Access-Control-Allow-Credentials'	=> 'true');
	header('Access-Control-Max-Age'		=> 60),	# seconds
	header('Access-Control-Allow-Headers'	=> join(', ',@headers) ) if @headers;
	return to_json({ ok => 1 },{pretty => 0});
};

post '/cors/post' => sub {
	header('Access-Control-Allow-Origin'		=> 'http://0.0.0.0:3000');
	header('Access-Control-Allow-Credentials'	=> 'true');
  debug("POST param is ". (param('state')||'undef'));
	cookie('state' => param('state'), expires => "2 hours");
	return to_json({ ok => 1},{pretty => 0});
};

dance;
