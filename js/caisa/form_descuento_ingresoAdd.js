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
            var coddesingre = $("input#txtCodDesIngre").val();
            var namedesingre = $("input#txtNameDesIngre").val();
			var typedesingre = $("select#ddlTypeDesIngre").val();
			 var numbank = $("input#txtNumBank").val();
			
			
            //alert(datetermination);
            ////var firstName = name; // For Success/Failure Message
            // Check for white space in name for Success/Fail message
            ////if (firstName.indexOf(' ') >= 0) {
                ////firstName = name.split(' ').slice(0, -1).join(' ');
            ////}
            $.ajax({
                url: "./bin/form_descuento_ingresoAdd.php",
                type: "POST",
                data: {
                    coddesingre: coddesingre,
                    namedesingre: namedesingre,
                    typedesingre: typedesingre,
                    numbank: numbank
                },
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.info[i].status);
					if(data.status == 1)
					{
							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong>El Descuento/Ingreso fue registrado correctamente</strong>");
							$('#success > .alert-success').append('</div>');

							//clear all fields
							$('#form_descuento').trigger("reset");
					}
					else
					{
						    $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("NO se registro el Descuento/Ingreso");
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