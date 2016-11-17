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
         
            var dayholiday = formatDate($("input#txtDayHoliday").val());
			var celebration = $("input#txtCelebration").val();
	
            $.ajax({
                url: "./bin/form_dia_feriadoAdd.php",
                type: "POST",
                data: {
				    dayholiday:dayholiday,
				    celebration:celebration
				},
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.info[i].status);
					if(data.status == 1)
					{
							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong>El Dia Feriado fue registrado correctamente</strong>");
							$('#success > .alert-success').append('</div>');

							//clear all fields
							$('#form_diaferiado').trigger("reset");
					}
					else
					{
						    $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("NO se registro el Dia Feriado");
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