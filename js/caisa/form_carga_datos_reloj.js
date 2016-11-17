$(function() {
			
	$("input,select,textarea").jqBootstrapValidation({
        preventSubmit: true,
        submitError: function($form, event, errors) {
            // something to have when submit produces an error ?
            // Not decided if I need it yet
        },
        submitSuccess: function($form, event) {
            event.preventDefault(); // prevent default submit behaviour
            // get values from FORM
            //var codposition = $("input#txtCodPosition").val();
            //var nameposition = $("input#txtNamePosition").val();
		
				var myform = document.getElementById("form_carga");
				var fd = new FormData(myform );
            $.ajax({
                url: "./bin/form_carga_datos_reloj.php",
                type: "POST",
				data: fd,
                //data: {
                    //codposition: codposition,
                    //nameposition: nameposition
                //},
        processData: false,
        contentType: false,
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.status);
					if(data.status == 1)
					{
						 window.location.href = "form_carga_datos_relojList.html";	
					}
					else
					{
						  
					}
                },
                error: function() {
                    // Fail message
					
                  
                },
            })
        },
        filter: function() {
            return $(this).is(":visible");
        },
    });

});

/*$(function() {

 
    var options = { 
    beforeSend: function() 
    {
        $("#progress").show();
        clear everything
        $("#bar").width('0%');
        $("#message").html("");
        $("#percent").html("0%");
    },
    uploadProgress: function(event, position, total, percentComplete) 
    {
        $("#bar").width(percentComplete+'%');
        $("#percent").html(percentComplete+'%');
 
    },
    success: function() 
    {
        $("#bar").width('100%');
        $("#percent").html('100%');
 
    },
    complete: function(response) 
    {
        $("#message").html("<font color='green'>"+response.responseText+"</font>");
    },
    error: function()
    {
        $("#message").html("<font color='red'> ERROR: unable to upload files</font>");
 
    }
 
}; 
 
     $("#myForm").ajaxForm(options);
 
});*/