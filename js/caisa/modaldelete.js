$(function() {
   
	$.ajax({
		url: "./bin/modaldelete.php",
		type: "GET",
		cache: false,
        crossDomain: false,
		success: function(data) {
					 //alert(data.status);
				if (data.status == 1)
				{
					$("#IncludeModal").append(data.info);		
				}
		},
		error: function() {
			// Fail message
		},
	})
});
