$(function() {

	var id=getUrlVars()["id"];
	
	function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
	}
	
	$.ajax({
		url: "./bin/form_periodoDelete.php",
		type: "POST",
        data: {
			id:id
		},
		cache: false,
        crossDomain: false,
		success: function(data) {
				if (data.status == 1)
				{
					 window.location.href = "form_periodoList.html";	
				}
		},
		error: function() {
			// Fail message
		},
	});

});