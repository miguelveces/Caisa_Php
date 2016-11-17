$(function() {
		 //alert(getUrlVars()["id"]);
		 var id=getUrlVars()["id"];
		 getInfo(id);

		function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
		}
        function getInfo(id) {	
		    $.ajax({
				url: "./bin/form_jornadaEdit.php",
				type: "GET",
				data: "id=" + id,
				cache: false,
                crossDomain: false,
				success: function(data) {
				 
				
						if (data.status == 1)
						{
							$('#txtCodWorkingDay').val(data.info[0].codigo_jornada);
							$('#txtDescription').val(data.info[0].descripcion);
							$('#txtStart').val(data.info[0].hora_inicia);
							$('#txtEnd').val(data.info[0].hora_termina);
							$('#txtTotalHours').val(data.info[0].total_horas);
							$('#txtPay').val(data.info[0].paga);
							$('select[name="ddlTurn"]').find('option[value="'+data.info[0].id_turno+'"]').attr("selected",true);
							

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
			var codworkingday = $("input#txtCodWorkingDay").val();
            var description = $("input#txtDescription").val();
            var start = $("input#txtStart").val();
			var end = $("input#txtEnd").val();
            var totalhours = $("input#txtTotalHours").val();
			var pay = $("input#txtPay").val();
			var idturn = $("select#ddlTurn").val();
			var turn = $("select#ddlTurn option:selected").text();
			
			
            //alert(datetermination);
            ////var firstName = name; // For Success/Failure Message
            // Check for white space in name for Success/Fail message
            ////if (firstName.indexOf(' ') >= 0) {
                ////firstName = name.split(' ').slice(0, -1).join(' ');
            ////}
            $.ajax({
                url: "./bin/form_jornadaEdit.php",
                type: "POST",
                data: {
				    id:id,
				    codworkingday:codworkingday,
                    description:description,
                    start:start,
                    end:end,
				    totalhours:totalhours,
				    pay:pay,
					idturn:idturn,
				    turn:turn
				},
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.info[i].status);
					if(data.status == 1)
					{
							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong>La Jornada fue registrado correctamente</strong>");
							$('#success > .alert-success').append('</div>');

							//clear all fields
							$('#form_jornada').trigger("reset");
					}
					else
					{
						    $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("NO se registro la Jornada");
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


