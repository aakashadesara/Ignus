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
		user.set("cover", $("#coverSignUp").val());
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
		    console.log("Error: " + error.code + " " + error.message);
		  }
		});
  	});

   $("#loginButton").click(function(){
  		Parse.User.logIn($("#usernameLogin").val(), $("#passwordLogin").val(), {
		  success: function(user) {
		  	currentUser = Parse.User.current();
		  	console.log(currentUser);
		  	clearSignUpSheet();
		    $("#theForms").hide();
		   	addProfileInformation(user);
		   	
		   	//fillDataAtBottom(user);
		  },
		  error: function(user, error) {
		  	 console.log("Error: " + error.code + " " + error.message);
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
  	 						   "<div class=\"col-xs-6 col-md-3\">" +
  	 						   //"<a href=\"#\" class=\"thumbnail\">" +
							   "<img style=\"\"src=\"" + get_gravatar(user.get('email'), 150) + "\" alt=\"\" class=\"img-circle\">" +
							   //"</a>" +
							   "</div>" +
		 					   "<h1 style=\"background-color: rgba(255,255,255,.8);\">" + user.get("FirstName") + " " + user.get("LastName") + "<small></small></h1>" +
							   "</div>" +
	  						   "<p></p>" +
	  						   "<p><a class=\"btn btn-primary btn-lg\" href=\"#\" role=\"button\">Edit</a></p>" );

  	 $('#jumboBumboTron').css("background-image", "url(\"" + user.get('cover') + "\")");  

	 $("#navbarHolder").append(" <div id=\"stats\"> <ul class=\"nav navbar-nav navbar-left\">" +
								"<li><a href=\"#\">Profile </a></li>" +
								"<li class=\"\"><a id=\"friendRequests\">Requests  <span class=\"badge\"><div id=\"numberRequestBadges\"</span></a></li>" +
								"<li class=\"\"><a id=\"paymentRequests\">Payments  <span class=\"badge\"><div id=\"numberPaymentRequests\"</span></a></li>" +
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

	
	 $("#recentPayments").html("");
		var Payments = Parse.Object.extend("Payments");
		var payments = new Parse.Query(Payments);
		payments.equalTo("recipientUsername", user.get('username'));
		payments.find({
		  success: function(results) {
		    console.log("Successfully retrieved " + results.length + " scores.");
		    // Do something with the returned Parse.Object values
		    for (var i = 0; i < results.length; i++) { 
		      var object = results[i];
		      //console.log(object.id + ' - ' + object.get('playerName'));
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
		    console.log("Error: " + error.code + " " + error.message);
		  }
		});

		$("#sentPayments").html("");
		var Payments = Parse.Object.extend("Payments");
		var payments = new Parse.Query(Payments);
		payments.equalTo("senderUsername", user.get('username'));
		payments.find({
		  success: function(results) {
		    console.log("Successfully retrieved " + results.length + " scores.");
		    // Do something with the returned Parse.Object values
		    for (var i = 0; i < results.length; i++) { 
		      var object = results[i];
		      //console.log(object.id + ' - ' + object.get('playerName'));
		      $("#sentPayments").html($("#sentPayments").html() + 
											"<div class=\"panel panel-default\">" +
											"<div class=\"panel-body\">" +
											object.get('recipientUsername') + ' - $' + object.get('moneyOwed') + 
											"</div>" +
											"<div class=\"panel-footer\">" + object.get("memo") + "<br>" + object.updatedAt + "</div>" +
											"</div>");
		    }
		  },
		  error: function(error) {
		    console.log("Error: " + error.code + " " + error.message);
		  }
		});



	 $("#bottomInfoHolder").append("</div>"+
	 								"<div class=\"col-md-2\">" +
									"<h4 style=\"text-align: center\"> <u> Stats </u> </h4>" +
									"<p style=\"text-align: center;\"> Friends (" + percentage + "%) </p>" +
									"<div class=\"progress\">" +
									"<div class=\"progress-bar progress-bar-danger progress-bar-striped active\" role=\"progressbar\" aria-valuenow=\"" + percentage + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"height: 20px; width: " + percentage +"%\">" +
									"<span class=\"sr-only\">" + percentage + "% Complete (success)</span>" +

									"</div>" +

									"</div>" +
									"<h3 style=\"text-align: center;\">" + numFriends + "/" + goalFriends + "</h3>"+
									"</div>" +

									"</div>" +
									"<div class=\"col-md-2\">" +
									"<h4 style=\"text-align: center\"> <u> Recieved </u> </h4>" +
									"<div style=\"height: 25%; overflow-y: scroll; background-color: ; \" id=\"recentPayments\"></div>" + 
									"</div>" +
									"<div class=\"col-md-2\">" +
									"<h4 style=\"text-align: center\"> <u> Sent </u></h4>" +
									"<div style=\"height: 25%; overflow-y: scroll; background-color: ;\" id=\"sentPayments\"> </div>" +
									"</div>"+
									"<div class=\"col-md-2\">" +
									"<h4 style=\"text-align: center\"> <u> Friends </u></h4>" +
									"<div style=\"height: 25%; overflow-y: scroll; background-color: ;\" id=\"friendList\"> </div>" +
									"</div>" +
									"<div class=\"col-md-4\">" +
									"<h4 style=\"text-align: center\"> <u> Make Transaction </u></h4>" +
									"<div style=\"height: 25%; overflow-y: scroll; background-color: ;\" id=\"friendList\">" +
									"<div class=\"form-group col-md-6\">" +
									"<label class=\"control-label\" for=\"inputDefault\">Username</label>" +
									"<input id=\"sendToHolder\" type=\"text\" class=\"form-control\" id=\"inputDefault\">" +
									"</div>" +
									"<div class=\"form-group col-md-6\">" +
									"<label class=\"control-label\" for=\"inputDefault\">Money</label>" +
									"<input id=\"moneyHolder\" type=\"text\" class=\"form-control\" id=\"inputDefault\">" +
									"</div>" +
									"<div class=\"form-group col-md-9\">" +
									"<label class=\"control-label\" for=\"inputDefault\">Memo</label>" +
									"<input id=\"memoHolder\" type=\"text\" class=\"form-control\" id=\"inputDefault\">" +
									"</div>" +
									"<a id=\"confirmTranscription\" class=\"btn btn-primary\">Confirm</a>" +
									"</div>" +
									"</div>" +
									"</div>" +
									"</div>");

		$("#friendList").html("");
		for(var i = 0; i < user.get('Friends').length; i++){
			var User = Parse.Object.extend("User");
			var query = new Parse.Query(User);
			query.equalTo("username", user.get('Friends')[i]);
			query.find({
			  success: function(results) {
			    //console.log("Successfully retrieved YOYOYO" + results.length + " scores.");
			    // Do something with the returned Parse.Object values
			    for (var j = 0; j < results.length; j++) { 
			      var object = results[j];
			      //console.log(object.id + ' - ' + object.get('email'));
			      $("#friendList").html($("#friendList").html() + "<img style=\"\"src=\"" + get_gravatar(object.get('email'), 50) + "\" alt=\"\" class=\"img-circle\">" + " ");
			    }
			  },
			  error: function(error) {
			    console.log("Error: " + error.code + " " + error.message);
			  }
			});
			
		}

		$("#confirmTranscription").click(function(){
			var Payment = Parse.Object.extend("Payments");
			var payment = new Payment();
			payment.set('currentStatus', 'Requested');
			payment.set('memo', $("#memoHolder").val());
			payment.set('moneyOwed', parseFloat($("#moneyHolder").val()));
			payment.set("recipientUsername", user.get('username'));
			payment.set("senderUsername", $("#sendToHolder").val());
			payment.set("rating", "Undecided");
			payment.save(null, {
			  success: function(request) {
			    // Execute any logic that should take place after the object is saved.
			    console.log('Success');
			  },
			  error: function(reqiest, error) {
			    // Execute any logic that should take place if the save fails.
			    // error is a Parse.Error with an error code and message.
			    console.log('Failed to create new object, with error code: ' + error.message);
			  }
			});
		});

		
		
		$("#friendRequests").on("click", function(evt) {
			$("#searchResultsHolder").html("");
		  	var query = new Parse.Query('FriendRequests');
			query.equalTo("recipientUsername", user.get('username'));
			query.find({
			  success: function(results) {
			  	//console.log("LEngth is " + results.length);
			  	var amtOfRequestsList = [];
			  	for (var i = 0; i < results.length && amtOfRequestsList < 1; i++) { 

			      var object = results[i];

			      //console.log(object.id + ' - ' + object.get('username'));
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
						    	console.log(obj.get('senderUsername'));

						    	var addOrNot = true;
						    	for(var i = 0; i < friendList.length; i++){
						    		if(friendList[i] == obj.get('senderUsername')){
						    			addOrNot = false;
						    		}
						    	}
						    	if(addOrNot)
							    	friendList.push(obj.get('senderUsername'));
							    addOrNot = true;
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
					    console.log('Success');
					  },
					  error: function(reqiest, error) {
					    // Execute any logic that should take place if the save fails.
					    // error is a Parse.Error with an error code and message.
					    console.log('Failed to create new object, with error code: ' + error.message);
					  }
					});
				});
			  },
			  error: function(error) {
			    console.log("Error: " + error.code + " " + error.message);
			  }
			});

		});


		$("#searchButton").on("click", function(evt) {
		  	
			evt.preventDefault();
		  	var query = new Parse.Query(Parse.User);
			query.equalTo("username", $("#searchBox").val());
			query.find({
			  success: function(results) {
			  	//console.log("LEngth is " + results.length);
			  	for (var i = 0; i < results.length; i++) { 
			      var object = results[i];
			      //console.log(object.id + ' - ' + object.get('username'));
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
					    console.log('Success');
					  },
					  error: function(reqiest, error) {
					    // Execute any logic that should take place if the save fails.
					    // error is a Parse.Error with an error code and message.
					    console.log('Failed to create new object, with error code: ' + error.message);
					  }
					});
				});
			  },
			  error: function(error) {
			    console.log("Error: " + error.code + " " + error.message);
			  }
			});



		});
}

function get_gravatar(email, size) {
 
    // MD5 (Message-Digest Algorithm) by WebToolkit
    // 
 
    var MD5=function(s){function L(k,d){return(k<<d)|(k>>>(32-d))}function K(G,k){var I,d,F,H,x;F=(G&2147483648);H=(k&2147483648);I=(G&1073741824);d=(k&1073741824);x=(G&1073741823)+(k&1073741823);if(I&d){return(x^2147483648^F^H)}if(I|d){if(x&1073741824){return(x^3221225472^F^H)}else{return(x^1073741824^F^H)}}else{return(x^F^H)}}function r(d,F,k){return(d&F)|((~d)&k)}function q(d,F,k){return(d&k)|(F&(~k))}function p(d,F,k){return(d^F^k)}function n(d,F,k){return(F^(d|(~k)))}function u(G,F,aa,Z,k,H,I){G=K(G,K(K(r(F,aa,Z),k),I));return K(L(G,H),F)}function f(G,F,aa,Z,k,H,I){G=K(G,K(K(q(F,aa,Z),k),I));return K(L(G,H),F)}function D(G,F,aa,Z,k,H,I){G=K(G,K(K(p(F,aa,Z),k),I));return K(L(G,H),F)}function t(G,F,aa,Z,k,H,I){G=K(G,K(K(n(F,aa,Z),k),I));return K(L(G,H),F)}function e(G){var Z;var F=G.length;var x=F+8;var k=(x-(x%64))/64;var I=(k+1)*16;var aa=Array(I-1);var d=0;var H=0;while(H<F){Z=(H-(H%4))/4;d=(H%4)*8;aa[Z]=(aa[Z]|(G.charCodeAt(H)<<d));H++}Z=(H-(H%4))/4;d=(H%4)*8;aa[Z]=aa[Z]|(128<<d);aa[I-2]=F<<3;aa[I-1]=F>>>29;return aa}function B(x){var k="",F="",G,d;for(d=0;d<=3;d++){G=(x>>>(d*8))&255;F="0"+G.toString(16);k=k+F.substr(F.length-2,2)}return k}function J(k){k=k.replace(/rn/g,"n");var d="";for(var F=0;F<k.length;F++){var x=k.charCodeAt(F);if(x<128){d+=String.fromCharCode(x)}else{if((x>127)&&(x<2048)){d+=String.fromCharCode((x>>6)|192);d+=String.fromCharCode((x&63)|128)}else{d+=String.fromCharCode((x>>12)|224);d+=String.fromCharCode(((x>>6)&63)|128);d+=String.fromCharCode((x&63)|128)}}}return d}var C=Array();var P,h,E,v,g,Y,X,W,V;var S=7,Q=12,N=17,M=22;var A=5,z=9,y=14,w=20;var o=4,m=11,l=16,j=23;var U=6,T=10,R=15,O=21;s=J(s);C=e(s);Y=1732584193;X=4023233417;W=2562383102;V=271733878;for(P=0;P<C.length;P+=16){h=Y;E=X;v=W;g=V;Y=u(Y,X,W,V,C[P+0],S,3614090360);V=u(V,Y,X,W,C[P+1],Q,3905402710);W=u(W,V,Y,X,C[P+2],N,606105819);X=u(X,W,V,Y,C[P+3],M,3250441966);Y=u(Y,X,W,V,C[P+4],S,4118548399);V=u(V,Y,X,W,C[P+5],Q,1200080426);W=u(W,V,Y,X,C[P+6],N,2821735955);X=u(X,W,V,Y,C[P+7],M,4249261313);Y=u(Y,X,W,V,C[P+8],S,1770035416);V=u(V,Y,X,W,C[P+9],Q,2336552879);W=u(W,V,Y,X,C[P+10],N,4294925233);X=u(X,W,V,Y,C[P+11],M,2304563134);Y=u(Y,X,W,V,C[P+12],S,1804603682);V=u(V,Y,X,W,C[P+13],Q,4254626195);W=u(W,V,Y,X,C[P+14],N,2792965006);X=u(X,W,V,Y,C[P+15],M,1236535329);Y=f(Y,X,W,V,C[P+1],A,4129170786);V=f(V,Y,X,W,C[P+6],z,3225465664);W=f(W,V,Y,X,C[P+11],y,643717713);X=f(X,W,V,Y,C[P+0],w,3921069994);Y=f(Y,X,W,V,C[P+5],A,3593408605);V=f(V,Y,X,W,C[P+10],z,38016083);W=f(W,V,Y,X,C[P+15],y,3634488961);X=f(X,W,V,Y,C[P+4],w,3889429448);Y=f(Y,X,W,V,C[P+9],A,568446438);V=f(V,Y,X,W,C[P+14],z,3275163606);W=f(W,V,Y,X,C[P+3],y,4107603335);X=f(X,W,V,Y,C[P+8],w,1163531501);Y=f(Y,X,W,V,C[P+13],A,2850285829);V=f(V,Y,X,W,C[P+2],z,4243563512);W=f(W,V,Y,X,C[P+7],y,1735328473);X=f(X,W,V,Y,C[P+12],w,2368359562);Y=D(Y,X,W,V,C[P+5],o,4294588738);V=D(V,Y,X,W,C[P+8],m,2272392833);W=D(W,V,Y,X,C[P+11],l,1839030562);X=D(X,W,V,Y,C[P+14],j,4259657740);Y=D(Y,X,W,V,C[P+1],o,2763975236);V=D(V,Y,X,W,C[P+4],m,1272893353);W=D(W,V,Y,X,C[P+7],l,4139469664);X=D(X,W,V,Y,C[P+10],j,3200236656);Y=D(Y,X,W,V,C[P+13],o,681279174);V=D(V,Y,X,W,C[P+0],m,3936430074);W=D(W,V,Y,X,C[P+3],l,3572445317);X=D(X,W,V,Y,C[P+6],j,76029189);Y=D(Y,X,W,V,C[P+9],o,3654602809);V=D(V,Y,X,W,C[P+12],m,3873151461);W=D(W,V,Y,X,C[P+15],l,530742520);X=D(X,W,V,Y,C[P+2],j,3299628645);Y=t(Y,X,W,V,C[P+0],U,4096336452);V=t(V,Y,X,W,C[P+7],T,1126891415);W=t(W,V,Y,X,C[P+14],R,2878612391);X=t(X,W,V,Y,C[P+5],O,4237533241);Y=t(Y,X,W,V,C[P+12],U,1700485571);V=t(V,Y,X,W,C[P+3],T,2399980690);W=t(W,V,Y,X,C[P+10],R,4293915773);X=t(X,W,V,Y,C[P+1],O,2240044497);Y=t(Y,X,W,V,C[P+8],U,1873313359);V=t(V,Y,X,W,C[P+15],T,4264355552);W=t(W,V,Y,X,C[P+6],R,2734768916);X=t(X,W,V,Y,C[P+13],O,1309151649);Y=t(Y,X,W,V,C[P+4],U,4149444226);V=t(V,Y,X,W,C[P+11],T,3174756917);W=t(W,V,Y,X,C[P+2],R,718787259);X=t(X,W,V,Y,C[P+9],O,3951481745);Y=K(Y,h);X=K(X,E);W=K(W,v);V=K(V,g)}var i=B(Y)+B(X)+B(W)+B(V);return i.toLowerCase()};
 
    var size = size || 80;
 
    return 'http://www.gravatar.com/avatar/' + MD5(email) + '.jpg?s=' + size;
}


function refreshNavBar(type){
	if ( type == "profile"){
		$("#signInLoginButtonHolder").hide();
	} else if (type == "signInLogIn"){
		$("#signInLoginButtonHolder").show();
	}
}


