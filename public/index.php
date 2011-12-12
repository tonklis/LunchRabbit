<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
	<head>
		<title>Lunch Rabbit</title>
		<meta property="og:title" content="Lunch Rabbit" />
		<meta property="og:type" content="social" />
		<meta property="og:url" content="http://swdf.in2teck.com/" />
		
	 	<!-- Include support librarys first -->
		<script type="text/javascript" src="http://code.jquery.com/jquery-1.4.3.min.js"></script>
		<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.1/jquery-ui.min.js"></script>	
		<link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.1/themes/base/jquery-ui.css">
		
		<script type="text/javascript">
	
			var APP_ID = "316932864999658";			
			var REDIRECT_URI = "http://swdf.in2teck.com/register.php?";		
			var PERMS = "publish_stream,email,user_interests,user_birthday";

			document.domain = "in2teck.com";
			
			function loginResult() {
				window.location.reload();
			}
			
			//Redirect for authorization for application loaded in an iFrame on Facebook.com 
			function redirect(id,perms,uri) {
				var params = window.location.toString().slice(window.location.toString().indexOf('?'));
				params = params.toString().replace(/&/g, "%26");
				top.location = 'https://graph.facebook.com/oauth/authorize?client_id='+id+'&scope='+perms+'&redirect_uri='+uri+params;				 
			}
			
		</script>
  </head>
  
<?php
	define('FACEBOOK_SECRET', '25b7c93ff48f139e55984887babf1351');
	require 'facebook.php';

	function parse_signed_request($signed_request, $secret) {
	  list($encoded_sig, $payload) = explode('.', $signed_request, 2); 

	  // decode the data
	  $sig = base64_url_decode($encoded_sig);
	  $data = json_decode(base64_url_decode($payload), true);

	  if (strtoupper($data['algorithm']) !== 'HMAC-SHA256') {
		error_log('Unknown algorithm. Expected HMAC-SHA256');
		return null;
	  }

	  // check sig
	  $expected_sig = hash_hmac('sha256', $payload, $secret, $raw = true);
	  if ($sig !== $expected_sig) {
		error_log('Bad Signed JSON signature!');
		return null;
	  }

	  return $data;
	}

	function base64_url_decode($input) {
	  return base64_decode(strtr($input, '-_', '+/'));
	}
	
	function registraUsuario($user) {
		$request = 'http://swdf.in2teck.com/usuarios/encuentra_o_crea/'.$user['user_id'].'.json';
		$session = curl_init($request);
		//curl_setopt($session, CURLOPT_VERBOSE, false);
		$response = curl_exec($session);
		//$update = 'http://swdf.in2teck.com/usuarios/actualiza'
		curl_close($session); 
	}
	
	$facebook = new Facebook(array(
	  'appId'  => '316932864999658',
	  'secret' => '25b7c93ff48f139e55984887babf1351',
	));
	$user = $facebook->getUser();
	
	if ($user) {
		try {
			// Proceed knowing you have a logged in user who's authenticated.
			$user_profile = $facebook->api('/me');
			print_r($user_profile);
		} catch (FacebookApiException $e) {
			error_log($e);
			$user = null;
		}
	}
	
	if ($_REQUEST['signed_request']) {
		$response = parse_signed_request($_REQUEST['signed_request'], FACEBOOK_SECRET);
		//registraUsuario($response);
	  /*echo '<pre>';
	  print_r($response);
	  echo '</pre>';*/
	}
?>
  <body>
    <div id="fb-root"></div>
	<script type="text/javascript">
		window.fbAsyncInit = function() {
			FB.init({appId: APP_ID, status: true, cookie: true, xfbml: true, oauth: true});
			FB.getLoginStatus(function(response) {
						if (!response.authResponse) {
							redirect(APP_ID, PERMS, REDIRECT_URI);
						}
					});
		};
		FB.Event.subscribe('auth.login', function(response) {
          window.location.reload();
        });
        FB.Event.subscribe('auth.logout', function(response) {
          window.location.reload();
        });
		
		(function() {
			var e = document.createElement('script');
			e.type = 'text/javascript';
			e.src = document.location.protocol +
				'//connect.facebook.net/en_US/all.js';
			e.async = true;
			document.getElementById('fb-root').appendChild(e);
		}());
	</script>
	</body>
</html>
