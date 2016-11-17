$(function() {
	function formatDate(dt) {
				
				var fdate="";
				if(dt!="")
				{
					var df = dt.split('-');
				   fdate = df[2]+'-'+df[1]+'-'+df[0];
				}
				
				return fdate;
	}
	$.ajax({
		url: "./bin/form_calculo_planilla_quincenal.php",
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
            event.preventDefault(); // prevent default submit behaviour
            // get values from FORM
            //var numcompany = $("input#txtNumcompany").val(); 
			//onclick="waitingDialog.show();setTimeout(function () {waitingDialog.hide();}, 3000);"
			//waitingDialog.show();
			
			$('#pleaseWaitDialog').modal('show');
            var numberfortnight = $("input#txtNumberFortnight").val();
            var paymentdate = formatDate($("input#txtPaymentDate").val());
			var thirteenth = $("select#ddlThirteenth").val();
            $.ajax({
                url: "./bin/form_calculo_planilla_quincenal.php",
                type: "POST",
                data: {
				    numberfortnight:numberfortnight,
					paymentdate:paymentdate,
					thirteenth:thirteenth
				},
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.info[i].status);
					if(data.status == 0)
					{
					        $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("NO se genero el calculo de la planilla");
							$('#success > .alert-danger').append('</div>');
							
					}
					else if(data.status == 1)
					{

							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong>Se genero el calculo de la planilla correctamente</strong>");
							$('#success > .alert-success').append('</div>');
							$('#pleaseWaitDialog').modal('hide');
							

					}
					else 
					{
	
							$('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("<strong>Ya el calculo de la planilla para este periodo se genero </strong>");
							$('#success > .alert-danger').append('</div>');
							
							$('#pleaseWaitDialog').modal('hide');
							
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