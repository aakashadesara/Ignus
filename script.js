$( document ).ready(function() {

	var currentUser = null;

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
		user.set("Friends", []);
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
		  	alert(currentUser);
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
	  						   "<p><a class=\"btn btn-primary btn-lg\" href=\"#\" role=\"button\">Edit</a></p>" );
	 $("#navbarHolder").append(" <div id=\"stats\"> <ul class=\"nav navbar-nav navbar-left\">" +
								"<li><a href=\"#\">Profile </a></li>" +
								"<li class=\"\"><a id=\"friendRequests\">Requests  <span class=\"badge\"><div id=\"numberRequestBadges\"</span></a></li>" +
								"<li class=\"\"><a href=\"#\">Messages <span class=\"badge\"><div id=\"numberMessagesBadge\"</span></a></li>" +
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

	 var numFriends = user.get("Friends").length;
	 var goalFriends;
	 if(numFriends < 10){
	 	goalFriends = 10;
	 } else if (numFriends < 100){
	 	goalFriends = 100;
	 } else if (numFriends < 1000){
	 	goalFriends = 1000;
	 } else if (numFriends < 10000){
	 	goalFriends = 10000;
	 } else if (numFriends < 100000){
	 	goalFriends = 100000;
	 } else if (numFriends < 1000000){
	 	goalFriends = 1000000;
	 } else if (numFriends < 10000000){
	 	goalFriends = 10000000;
	 }
	 var percentage = (numFriends / goalFriends) * 100;

	 $("#bottomInfoHolder").append(" <div class=\"col-md-2\">" +
									"<h4 style=\"text-align: center\"> <u> Statistics </u> </h4>" +
									"<p style=\"text-align: center;\"> Friends (" + percentage + "%) </p>" +
									"<div class=\"progress\">" +
									"<div class=\"progress-bar progress-bar-success progress-bar-striped active\" role=\"progressbar\" aria-valuenow=\"" + percentage + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width:" + percentage +"%\">" +
									"<span class=\"sr-only\">" + percentage + "% Complete (success)</span>" +
									"</div>" +
									"</div>" +
									"<p style=\"text-align: center;\"> Transactions </p>" +
									"<div class=\"progress\">" +
									"<div class=\"progress-bar progress-bar-danger progress-bar-striped active\" role=\"progressbar\" aria-valuenow=\"20\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 20%\">" +
									"<span class=\"sr-only\">20% Complete</span>" +
									"</div>" +
									"</div>" +
									"<p style=\"text-align: center;\">  Rating </p>" +
									"<div class=\"progress\">" +
									"<div class=\"progress-bar progress-bar-warning progress-bar-striped active\" role=\"progressbar\" aria-valuenow=\"60\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 60%\">" +
									"<span class=\"sr-only\">60% Complete (warning)</span>" +
									"</div> " +
									"</div>" +
									"</div>" +
									"<div class=\"col-md-2\">" +
									"<h4 style=\"text-align: center\"> <u> Recieved </u> </h4>" +
									"<div style=\"height: 25%; overflow-y: scroll; background-color: ; \" id=\"recentPayments\"></div>" + 
									"</div>" +
									"<div class=\"col-md-2\">" +
									"<h4 style=\"text-align: center\"> <u> Sent </u> </h4>" +
									"</div>");

		$("#recentPayments").html("");
		var Payments = Parse.Object.extend("Payments");
		var payments = new Parse.Query(Payments);
		payments.equalTo("recipientUsername", user.get('username'));
		payments.find({
		  success: function(results) {
		    alert("Successfully retrieved " + results.length + " scores.");
		    // Do something with the returned Parse.Object values
		    for (var i = 0; i < results.length; i++) { 
		      var object = results[i];
		      //alert(object.id + ' - ' + object.get('playerName'));
		      $("#recentPayments").html($("#recentPayments").html() + 
											"<div class=\"panel panel-default\">" +
											"<div class=\"panel-body\">" +
											object.get('senderUsername') + ' - $' + object.get('moneyOwed') + 
											"</div>" +
											"<div class=\"panel-footer\">" + object.get("memo") + "<br>" + object.updatedAt + "</div>" +
											"</div>");
		    }
		  },
		  error: function(error) {
		    alert("Error: " + error.code + " " + error.message);
		  }
		});
		
		$("#friendRequests").on("click", function(evt) {
			$("#searchResultsHolder").html("");
		  	var query = new Parse.Query('FriendRequests');
			query.equalTo("recipientUsername", user.get('username'));
			query.find({
			  success: function(results) {
			  	//alert("LEngth is " + results.length);
			  	var amtOfRequestsList = [];
			  	for (var i = 0; i < results.length && amtOfRequestsList < 1; i++) { 

			      var object = results[i];

			      //alert(object.id + ' - ' + object.get('username'));
			      if(object.get('currentStatus') == "Requested"){		
			      	amtOfRequestsList += object;	      

			   		 $("#searchResultsHolder").html($("#searchResultsHolder").html() + "<div class=\"panel panel-primary\">" +
												"<div class=\"panel-heading\">" +
												"<h2 class=\"panel-title\">" + "Friend Requests" +"</h2>" +
												"</div>" +
												"<div class=\"panel-body\">" +
												object.get('currentStatus') + " - " + object.get('senderUsername') + " "+
												"<a id=\"accept" + object.id + "\" class=\"btn btn-success\">Accept</a> " +
												"<a id=\"delete" + object.id + "\" class=\"btn btn-danger\">Delete</a>" +
												"</div>" +
												"</div>"
												);
			   		 var objectId = object.id;
			   		$("#accept" + objectId).click(function() {
			   		 	var FriendRequests = Parse.Object.extend("FriendRequests");
						
						var query = new Parse.Query(FriendRequests);
						query.get(objectId, {
						  success: function(obj) {
						    	obj.set('currentStatus', "Accepted");
						    	obj.save();
						    	$("#searchResultsHolder").html("");

						    	var friendList = user.get('Friends');
						    	alert(obj.get('senderUsername'));

						    	var addOrNot = true;
						    	for(var i = 0; i < friendList.length; i++){
						    		if(friendList[i] == obj.get('senderUsername')){
						    			addOrNot = false;
						    		}
						    	}
						    	if(addOrNot)
							    	friendList.push(obj.get('senderUsername'));
						    	user.set('Friends', friendList);
						    	user.save();

						  },
						  error: function(object, error) {
						    // The object was not retrieved successfully.
						    // error is a Parse.Error with an error code and message.
						  }
						});

			   		 });

			   		$("#delete" + objectId).click(function() {
			   		 	var FriendRequests = Parse.Object.extend("FriendRequests");
						
						var query = new Parse.Query(FriendRequests);
						query.get(objectId, {
						  success: function(obj) {
						    	obj.set('currentStatus', "Declined");
						    	obj.save();
						    	$("#searchResultsHolder").html("");
						  },
						  error: function(object, error) {
						    // The object was not retrieved successfully.
						    // error is a Parse.Error with an error code and message.
						  }
						});

			   		 });
			   	}
			}
			  //  $("#searchResultsHolder").html(object.id + ' - ' + object.get('username') + ' - ' + object.get('FirstName')+ ' - ' + object.get('email'));
			    $("#sendRequest").click(function(){
					var FriendRequest = Parse.Object.extend("FriendRequests");
					var friendRequest = new FriendRequest();
					friendRequest.set('currentStatus', 'Requested');
					friendRequest.set('recipientUsername', object.get('username'));
					friendRequest.set('senderUsername', user.get('username'));
					friendRequest.save(null, {
					  success: function(request) {
					    // Execute any logic that should take place after the object is saved.
					    alert('Success');
					  },
					  error: function(reqiest, error) {
					    // Execute any logic that should take place if the save fails.
					    // error is a Parse.Error with an error code and message.
					    alert('Failed to create new object, with error code: ' + error.message);
					  }
					});
				});
			  },
			  error: function(error) {
			    alert("Error: " + error.code + " " + error.message);
			  }
			});

		});


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
			    $("#sendRequest").click(function(){
					var FriendRequest = Parse.Object.extend("FriendRequests");
					var friendRequest = new FriendRequest();
					friendRequest.set('currentStatus', 'Requested');
					friendRequest.set('recipientUsername', object.get('username'));
					friendRequest.set('senderUsername', user.get('username'));
					friendRequest.save(null, {
					  success: function(request) {
					    // Execute any logic that should take place after the object is saved.
					    alert('Success');
					  },
					  error: function(reqiest, error) {
					    // Execute any logic that should take place if the save fails.
					    // error is a Parse.Error with an error code and message.
					    alert('Failed to create new object, with error code: ' + error.message);
					  }
					});
				});
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
