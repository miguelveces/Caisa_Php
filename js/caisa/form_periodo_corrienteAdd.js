$(function() {
	function formatDate(dt) {
			var df = dt.split('-');
			var fdate = df[2]+'-'+df[1]+'-'+df[0];
	  return fdate;
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
            //var numcompany = $("input#txtNumcompany").val();
            var yearfiscal = $("input#txtYearFiscal").val();
			var payfrecuencia = $("select#ddlPayFrecuencia").val();
			var numberperiodo = $("input#txtNumberPeriodo").val();
            var datepay = formatDate($("input#txtDatePay").val());
			var dated = formatDate($("input#txtDateD").val());
            var dateh = formatDate($("input#txtDateH").val());
			var secuence = $("input#txtSecuence").val();
	
            $.ajax({
                url: "./bin/form_periodo_corrienteAdd.php",
                type: "POST",
                data: {
                    //numcompany:numcompany,
                    yearfiscal:yearfiscal, 
					payfrecuencia:payfrecuencia,
                    numberperiodo:numberperiodo,
                    datepay:datepay,
				    dated:dated,
				    dateh:dateh,
				    secuence:secuence
				},
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.info[i].status);
					if(data.status == 1)
					{
							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong>El Periodo fue registrado correctamente</strong>");
							$('#success > .alert-success').append('</div>');

							//clear all fields
							$('#form_periodo').trigger("reset");
					}
					else
					{
						    $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("NO se registro el Periodo");
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