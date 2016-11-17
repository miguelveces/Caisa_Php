$(function() {
	
		/*	$.ajax({
			url: "./bin/form_seccionEdit.php",
			type: "GET",
			//data: "sw=" + 1,
			cache: false,
			crossDomain: false,
			success: function(data) { //Si se ejecuta correctamente
			  
				if(data.status == 1)
				{			
					
					$('#ddlDepart').empty();
					$('#ddlDepart').append(data.depart);
					$('#ddlDepart').trigger('liszt:updated');
				}

			},
			error: function(data){
			 //En caso de error mostramos una ventan a de error.
			//$('#msjError').popup( "open" );
			}
		 
		})*/
		
	
	
		 //alert(getUrlVars()["id"]);
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
				url: "./bin/form_seccionEdit.php",
				type: "GET",
				data: "id=" + id,
				cache: false,
                crossDomain: false,
				success: function(data) {
				 //alert(data.info[0].id_fk_rol);
				
						if (data.status == 1)
						{
							$('#txtCodSeccion').val(data.info[0].codigo_seccion);
							$('#txtNameSeccion').val(data.info[0].nombre_seccion);
//$('#ddlDepart').val(data.info[0].nombre_departamento);
							$('#ddlDepart').empty();
							$('#ddlDepart').append(data.depart);
							$('#ddlDepart').trigger('liszt:updated');
							//$('select[name="ddlRoles"]').find('option[value="'+data.info[0].id_fk_rol+'"]').attr("selected",true);
							//$('select[name="ddlStates"]').find('option[value="'+data.info[0].id_fk_estado+'"]').attr("selected",true);
							//$('ddlRoles > option[value="'.data.info[0].id_fk_rol.'"]').attr('selected', 'selected');
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
            var codseccion = $("input#txtCodSeccion").val();
            var nameseccion = $("input#txtNameSeccion").val();
	        var depart = $("select#ddlDepart").val();
           
            $.ajax({
                url: "./bin/form_seccionEdit.php",
                type: "POST",
                data: {
                    id:id, 
                    codseccion: codseccion,
                    nameseccion: nameseccion,
					depart : depart
		
                },
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(id);
					if(data.status == 1)
					{
							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong>La Seccion fue Modificada correctamente</strong>");
							$('#success > .alert-success').append('</div>');

							//clear all fields
							//$('#form_departamento').trigger("reset");
					}
					else
					{
						    $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("NO se Modifico La Seccion");
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


