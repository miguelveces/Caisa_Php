$(function() {
    var id=0;
	//var launch="";
	function formatDate(dt) {
			var df = dt.split('-');
			var fdate = df[2]+'-'+df[1]+'-'+df[0];
	  return fdate;
	}
	function url_redirect(options){
                 var $form = $("<form />");
                 
                 $form.attr("action",options.url);
                 $form.attr("method",options.method);
                 $form.attr("target",options.target);
                 for (var data in options.data)
                 $form.append('<input type="hidden" name="'+data+'" value="'+options.data[data]+'" />');
                  
                 $("body").append($form);
                 $form.submit();
    }
             

    $.ajax({
				url: "./bin/form_reporte_talonario.php",
				type: "GET",
				cache: false,
                crossDomain: false,
				success: function(data) {
				 
				
						if (data.status == 1)
						{
						    id=data.info[0].id_periodo;
							$('#txtNumberPeriodo').val(data.info[0].numero_periodo);
							$('#txtDateD').val(formatDate(data.info[0].fecha_desde));
							$('#txtDateH').val(formatDate(data.info[0].fecha_hasta));
							
							

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
                    
			var numberperiodo = $("input#txtNumberPeriodo").val();
			var dated = $("input#txtDateD").val();
            var dateh = $("input#txtDateH").val();
			url_redirect({url: "./bin/pdf_reporte_talonario.php",
            method: "get",
			target: "_blank", 
            data: {id:id,numberperiodo:numberperiodo,dated:dated,dateh:dateh}
             });
	
       
			
        },
        filter: function() {
            return $(this).is(":visible");
        },

    });

});