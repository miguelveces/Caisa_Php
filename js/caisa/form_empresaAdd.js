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
            //var numcompany = $("input#txtNumcompany").val();
            var legalrepres = $("input#txtLegalrepres").val();
			var address = $("input#txtAddress").val();
            var zip = $("input#txtZip").val();
			var phone = $("input#txtPhone").val();
            var comment = $("input#txtComment").val();
			var namecompany = $("input#txtNamecompany").val();
			var activitycode = $("select#ddlActivitycode").val();
			
			
            //alert(datetermination);
            ////var firstName = name; // For Success/Failure Message
            // Check for white space in name for Success/Fail message
            ////if (firstName.indexOf(' ') >= 0) {
                ////firstName = name.split(' ').slice(0, -1).join(' ');
            ////}
            $.ajax({
                url: "./bin/form_empresaAdd.php",
                type: "POST",
                data: {
                    //numcompany:numcompany,
                    legalrepres:legalrepres, 
					address:address,
                    zip:zip,
                    phone:phone,
				    comment:comment,
				    namecompany:namecompany,
				    activitycode:activitycode
				},
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.info[i].status);
					if(data.status == 1)
					{
							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong>La Empresa fue registrada correctamente</strong>");
							$('#success > .alert-success').append('</div>');

							//clear all fields
							$('#form_usuario').trigger("reset");
					}
					else
					{
						    $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("NO se registro la Empresa");
							$('#success > .alert-danger').append('</div>');
							//clear all fields
							//$('#form_usuario').trigger("reset");
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