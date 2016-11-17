$(function() {
		 
		 var id=getUrlVars()["id"];
		 getInfoUser(id);

		function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
		}
        function getInfoUser(id) {	
		    $.ajax({
				url: "./bin/form_cuenta_banco_empleado.php",
				type: "GET",
				data: "id=" + id,
				cache: false,
                crossDomain: false,
				success: function(data) {
				 //alert(data.info[0].id_fk_rol);
				
						if (data.status == 1)
						{
							$('#txtNumEmployee').val(data.info[0].numero_empleado);
							$('#txtNameEmployee').val(data.info[0].nombre);
							$('#txtNumBank').val(data.info[0].numero_cuenta);
							$('select[name="ddlTypeCta"]').find('option[value="'+data.info[0].id_tipo_cuenta+'"]').attr("selected",true);
							$('#ddlBanks').append(data.banks);

						}		
				},
				error: function() {
					// Fail message
				},
			})
        }

$("input,select,textarea").jqBootstrapValidation({
        preventSubmit: true,
        submitError: function($form, event, errors) {
            // something to have when submit produces an error ?
            // Not decided if I need it yet
        },
        submitSuccess: function($form, event) {
            event.preventDefault(); // prevent default submit behaviour
            // get values from FORM
            var numemployee = $("input#txtNumEmployee").val();
           // var nameemployee = $("input#txtNameEmployee").val();
			var numbank = $("input#txtNumBank").val();
			var idtypecta = $("select#ddlTypeCta").val();
			var typecta = $("select#ddlTypeCta option:selected").text();
			var banks = $("select#ddlBanks").val();
            
            ////var firstName = name; // For Success/Failure Message
            // Check for white space in name for Success/Fail message
            ////if (firstName.indexOf(' ') >= 0) {
                ////firstName = name.split(' ').slice(0, -1).join(' ');
            ////}
            $.ajax({
                url: "./bin/form_cuenta_banco_empleado.php",
                type: "POST",
                data: {
				    id:id, 
                    numemployee: numemployee,
                    numbank: numbank,
                    idtypecta: idtypecta,
					typecta: typecta,
                    banks: banks
                },
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(id);
					if(data.status == 1)
					{
							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong>La Cuenta fue Modificado correctamente</strong>");
							$('#success > .alert-success').append('</div>');

							//clear all fields
							$('#form_cuenta').trigger("reset");
					}
					else
					{
						    $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("La Cuenta NO se Modifico al Empleado");
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


