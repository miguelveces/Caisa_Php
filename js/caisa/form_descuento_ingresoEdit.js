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
			url: "./bin/form_descuento_ingresoEdit.php",
			type: "GET",
                        data: "id=" + id,
			cache: false,
			crossDomain: false,
			success: function(data) { //Si se ejecuta correctamente
				if(data.status == 1)
				{
					 $('#txtCodDesIngre').val(data.info[0].cod_descuento_ingreso);
							$('#txtNameDesIngre').val(data.info[0].nombre_descuento_ingreso);
							$('select[name="ddlTypeDesIngre"]').find('option[value="'+data.info[0].tipo+'"]').attr("selected",true);
                                                         $('#txtNumBank').val(data.info[0].numero_cuenta);
				}

			},
			error: function(data){
			 //En caso de error mostramos una ventan a de error.
			//$('#msjError').popup( "open" );
			}
		 
		})	
	
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
                url: "./bin/form_descuento_ingresoEdit.php",
                type: "POST",
                data: {
                    id:id,
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