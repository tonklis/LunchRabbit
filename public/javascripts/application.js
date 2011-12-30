// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

    // VERSION_PROD
    //var APP_ID = "316932864999658";
    var APP_ID = "185077511587462";
    //var HOST = "http://glowing-moon-5161.heroku.com"
    var HOST = "http://localhost:3000"
    //document.domain = "heroku.com"
    document.domain = "localhost";

    window.fbAsyncInit = function() {
      FB.init({appId: APP_ID, status: true, cookie: true, xfbml: true,  oauth: true});
      FB.getLoginStatus(function(response) {
		if (response.status == 'connected') {
                  //top.location = HOST + $("#app_paths")[0].getAttribute("data-oauth-path");
		}
	  });
	  FB.Event.subscribe('auth.login', function(response) {
            top.location = HOST + $("#app_paths")[0].getAttribute("data-oauth-path");
          });
      FB.Event.subscribe('auth.logout', function(response) {
        // falta poner logout
        top.location = HOST;
      });
    };    

