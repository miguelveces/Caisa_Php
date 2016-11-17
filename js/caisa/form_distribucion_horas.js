$(function() {
    $.ajax({
		url: "./bin/form_distribucion_horas.php",
		type: "GET",
		cache: false,
		crossDomain: false,
		success: function(data) {
		 
		
				if (data.status == 1)
				{
					id=data.info[0].id_periodo;
					$('#txtYearFiscal').val(data.info[0].anno_fiscal);
					$('#txtNumberPeriodo').val(data.info[0].numero_periodo);

				}		
		},
		error: function() {
			// Fail message
		},
	})

	$("input,select,textarea").jqBootstrapValidation({
        preventSubmit: true,
        submitError: function($form, event, errors) {
            // something to have when submit produces an error ?
            // Not decided if I need it yet
        },
        submitSuccess: function($form, event) {
		$('#pleaseWaitDialog').modal('show');
            event.preventDefault(); // prevent default submit behaviour
                    
			var numberperiodo = $("input#txtNumberPeriodo").val();
			var yearfiscal = $("input#txtYearFiscal").val();
            
			$.ajax({
                url: "./bin/form_distribucion_horas.php",
                type: "POST",
                data: {
					id: id,
                    numberperiodo: numberperiodo,
                    yearfiscal: yearfiscal
                },
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.info[i].status);
					if(data.status == 1)
					{
						$('#pleaseWaitDialog').modal('hide');
						 window.location.href = "form_registro_transacciones_planilla_regularList.html";
							//$('#success').html("<div class='alert alert-success'>");
							//$('#success > .alert-success').append("<strong>El Cargo fue registrado correctamente</strong>");
							//$('#success > .alert-success').append('</div>');

							//clear all fields
							//$('#form_cargo').trigger("reset");
					}
					else
					{
						   // $('#success').html("<div class='alert alert-danger'>");
							//$('#success > .alert-danger').append("NO se registro el Cargo");
							//$('#success > .alert-danger').append('</div>');
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