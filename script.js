$( document ).ready(function() {

	var currentUser;

	$("#loginForm").hide();

	var username = "";
	var password = "";
	var passwordConfirm = "";

   Parse.initialize("fjYfbEfwdbgSpkT7UbRAupclljULORQlm2NeSLyr", "ngLdPxqYU6p3zZyvYj2tfxo58Y7rMMqA25u2xQ8s");



   $("#signupButton").click(function(){
  		var user = new Parse.User();
  		user.set("FirstName", 	$("#firstNameSignUp").val());
  		user.set("LastName", 	$("#lastNameSignUp").val());
		user.set("username", $("#usernameSignUp").val());
		user.set("password", $("#passwordSignUp").val());
		user.set("email", 	$("#emailSignUp").val());

		user.signUp(null, {
		  success: function(user) {
		  	currentUser = Parse.User.current();
		    // Hooray! Let them use the app now.
		    clearSignUpSheet();
		    $("#theForms").hide();
		   	addProfileInformation(user);
		   	
		  },
		  error: function(user, error) {
		    // Show the error message somewhere and let the user try again.
		    alert("Error: " + error.code + " " + error.message);
		  }
		});
  	});

   $("#loginButton").click(function(){
  		Parse.User.logIn($("#usernameLogin").val(), $("#passwordLogin").val(), {
		  success: function(user) {
		  	currentUser = Parse.User.current();
		  	clearSignUpSheet();
		    $("#theForms").hide();
		   	addProfileInformation(user);
		   	
		   	//fillDataAtBottom(user);
		  },
		  error: function(user, error) {
		  	 alert("Error: " + error.code + " " + error.message);
		  }
		});
  	});

});

function clearSignUpSheet(){
	$("#firstNameSignUp").val("");
	$("#lastNameSignUp").val("");
	$("#usernameSignUp").val("");
	$("#passwordSignUp").val("");
	$("#emailSignUp").val("");

	$("#usernameLogin").val("");
	$("#passwordLogin").val("");
}

function addProfileInformation(user){
  	 $( "#bioHolder" ).append( "<div class=\"page-header\">" +
		 					   "<h1>" + user.get("FirstName") + " " + user.get("LastName") + "<small></small></h1>" +
							   "</div>" +
	  						   "<p></p>" +
	  						   "<p><a class=\"btn btn-primary btn-lg\" href=\"#\" role=\"button\">Message</a></p>" );
	 $("#navbarHolder").append(" <div id=\"stats\"> <ul class=\"nav navbar-nav navbar-left\">" +
								"<li><a href=\"#\">Profile </a></li>" +
								"<li class=\"\"><a href=\"#\">Friends <span class=\"badge\">4</span></a></li>" +
								"<li class=\"\"><a href=\"#\">Messages <span class=\"badge\">4</span></a></li>" +
								"<li class=\"\"><a href=\"#\">Payment</a></li> " +
								"</ul>" +
								"<ul class=\"nav navbar-nav navbar-right\">" +
								"<form class=\"navbar-form navbar-left\" role=\"search\">" +
								"<div class=\"form-group\">" +
								"<input type=\"text\" id=\"searchBox\" class=\"form-control\" placeholder=\"Search\">" +
								"</div>" +
								"<button id=\"searchButton\" class=\"btn btn-danger\">Search</button>" +
								"<button id=\"logout\" class=\"btn btn-default\">Logout</button>" +
								"</form>" +
								"</li>" +
								"</ul> </div>"); 

	 $("#bottomInfoHolder").append(" <div class=\"col-md-4\">" +
									"<h5> <u> Statistics </u> </h5>" +
									"<p style=\"text-align: center;\"> Friends </p>" +
									"<div class=\"progress\">" +
									"<div class=\"progress-bar progress-bar-success progress-bar-striped\" role=\"progressbar\" aria-valuenow=\"40\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 40%\">" +
									"<span class=\"sr-only\">40% Complete (success)</span>" +
									"</div>" +
									"</div>" +
									"<p style=\"text-align: center;\"> Transactions </p>" +
									"<div class=\"progress\">" +
									"<div class=\"progress-bar progress-bar-danger progress-bar-striped\" role=\"progressbar\" aria-valuenow=\"20\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 20%\">" +
									"<span class=\"sr-only\">20% Complete</span>" +
									"</div>" +
									"</div>" +
									"<p style=\"text-align: center;\">  Rating </p>" +
									"<div class=\"progress\">" +
									"<div class=\"progress-bar progress-bar-warning progress-bar-striped\" role=\"progressbar\" aria-valuenow=\"60\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 60%\">" +
									"<span class=\"sr-only\">60% Complete (warning)</span>" +
									"</div> " +
									"</div>" +
									"</div>" +
									"<div class=\"col-md-4\">" +
									"<h4> <u> Recent Payments </u> </h4>" +
									"</div>" +
									"<div class=\"col-md-4\">" +
									"<h4> <u> Recent Reviews </u> </h4>" +
									"</div>");

		$("#searchButton").on("click", function(evt) {
		  	
			evt.preventDefault();
		  	var query = new Parse.Query(Parse.User);
			query.equalTo("username", $("#searchBox").val());
			query.find({
			  success: function(results) {
			  	//alert("LEngth is " + results.length);
			  	for (var i = 0; i < results.length; i++) { 
			      var object = results[i];
			      //alert(object.id + ' - ' + object.get('username'));
			    }

			    $("#searchResultsHolder").html("<div class=\"panel panel-primary\">" +
												"<div class=\"panel-heading\">" +
												"<h2 class=\"panel-title\">" + object.get('username') +"</h2>" +
												"</div>" +
												"<div class=\"panel-body\">" +
												object.get('FirstName') + " " + object.get('LastName') + "<br> "+
												object.get('email') + "<br><br> " +
												"<a id=\"messageFriend\" class=\"btn btn-success\">Message</a> " +
												"<a id=\"sendRequest\" class=\"btn btn-primary\">Send Friend Request</a>" +
												"</div>" +
												"</div>"
												);

			  //  $("#searchResultsHolder").html(object.id + ' - ' + object.get('username') + ' - ' + object.get('FirstName')+ ' - ' + object.get('email'));
			    
			  },
			  error: function(error) {
			    alert("Error: " + error.code + " " + error.message);
			  }
			});

		});
}



function refreshNavBar(type){
	if ( type == "profile"){
		$("#signInLoginButtonHolder").hide();
	} else if (type == "signInLogIn"){
		$("#signInLoginButtonHolder").show();
	}
}
