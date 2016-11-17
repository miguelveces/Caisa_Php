$(function() {
		 //alert(getUrlVars()["id"]);
		 var id=getUrlVars()["id"];
		 var idworkingdayemployee=getUrlVars()["idworkingdayemployee"];
		 var infoworking;
		 //getInfo(idworkingdayemployee);

		function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
		}
		function formatDate(dt) {
				var df = dt.split('-');
				var fdate = df[2]+'-'+df[1]+'-'+df[0];
		  return fdate;
		}
		function formatDay(str) {
		 var replace = new Array("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"); 
		 var by = new Array("Lunes", "Martes", "Miercoles", "Jueves", "Vienes", "Sabado", "Domingo"); 
			for (var i=0; i<replace.length; i++) { 
				str = str.replace(replace[i], by[i]); 
				} 
		return str; 
		}
        $(function() 
		{
			$('#ddlWorkingDay').on('change', function()
			{
				//alert(infoworking[$(this).val()-1].total_horas - infoworking[$(this).val()-1].paga);
				$('#txtTimeEntry').val(infoworking[$(this).val()-1].hora_inicia);
				$('#txtTimeOut').val(infoworking[$(this).val()-1].hora_termina);
				$('#txtRegularTime').val(infoworking[$(this).val()-1].paga);
				$('#txtExtraTime').val((infoworking[$(this).val()-1].total_horas - infoworking[$(this).val()-1].paga === 0 ? '0.00' : infoworking[$(this).val()-1].total_horas - infoworking[$(this).val()-1].paga));
				//$('#txtExtraTime').val(infoworking[$(this).val()-1].total_horas - infoworking[$(this).val()-1].paga);
				
				
			});
		});
		$(function() 
		{
			$('#ddlIwork').on('change', function()
			{
				//alert($(this).val());
				$('#txtAbsence').val(($(this).val() === "0" ? 'L' : ''));
				
				
				
			});
		});
$.ajax({
				url: "./bin/form_empleado_tarjeta_tiempoEdit.php",
				type: "GET",
				data: "idworkingdayemployee=" + idworkingdayemployee,
				cache: false,
                crossDomain: false,
				success: function(data) {
				 $('#cancel').attr('href','form_empleado_tarjeta_tiempo.html?id='+ id)
				
						if (data.status == 1)
						{
							$('#txtDates').val(formatDate(data.info[0].fecha));
							$('#txtDay').val(formatDay(data.info[0].dia));
							$('select[name="ddlIwork"]').find('option[value="'+data.info[0].laboro+'"]').attr("selected",true);
							//$('#txtIwork').val(data.info[0].laboro);
							$('#txtAbsence').val(data.info[0].ausencia);
							$('#txtType').val(data.info[0].tipo);
							$('#txtCode').val(data.info[0].codigo);
							$('#ddlWorkingDay').append(data.workingdays);
							$('#txtCom').val(data.info[0].com);
							$('#txtTimeEntry').val(data.info[0].hora_entra);
							$('#txtTimeOut').val(data.info[0].hora_sale);
							$('#txtRegularTime').val(data.info[0].horas_regulares);
							$('#txtExtraTime').val(data.info[0].horas_extras);
							infoworking=data.infoworkingdays;

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
			//var dates = $("input#txtDates").val();
            //var day = $("input#txtDay").val();
			var iwork = $("select#ddlIwork").val();
			var absence = $("input#txtAbsence").val();
            var type = $("input#txtType").val();
			var code = $("input#txtCode").val();
			var workingday = $("select#ddlWorkingDay option:selected").text();
			var com = $("input#txtCom").val();
            var timeentry = $("input#txtTimeEntry").val();
			var timeout = $("input#txtTimeOut").val();
            var regulartime = $("input#txtRegularTime").val();
			var extratime = $("input#txtExtraTime").val();
					
            $.ajax({
                url: "./bin/form_empleado_tarjeta_tiempoEdit.php",
                type: "POST",
                data: {
				    idworkingdayemployee:idworkingdayemployee,
				    //dates:dates,
                    //day:day,
                    iwork:iwork,
                    absence:absence,
				    type:type,
				    code:code,
					workingday:workingday,
				    com:com,
					timeentry:timeentry,
					timeout:timeout,
					regulartime:regulartime,
					extratime:extratime
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
							$('#form_tarjeta').trigger("reset");
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


