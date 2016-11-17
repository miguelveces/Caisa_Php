$(function() {
		 //alert(getUrlVars()["id"]);
		 var id=getUrlVars()["id"];
		 //var idworkingdayemployee=getUrlVars()["idworkingdayemployee"];
		// var infoworking;
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
        
		$.ajax({
				url: "./bin/form_registro_transacciones_planilla_regularEdit.php",
				type: "GET",
				data: "id=" + id,
				cache: false,
                crossDomain: false,
				success: function(data) {
				 //$('#cancel').attr('href','form_empleado_tarjeta_tiempo.html?id='+ id)
				
						if (data.status == 1)
						{
							$('#txtEmployeeNum').val(data.info[0].numero_empleado);
							$('#txtLastNames').val(data.info[0].apellido);
							$('#txtNames').val(data.info[0].nombre);
							$('#txtPeriodo').val(data.infoperiod[0].numero_periodo);
							$('#txtDateD').val(formatDate(data.infoperiod[0].fecha_inicio));
							$('#txtDateH').val(formatDate(data.infoperiod[0].fecha_final));
							$('#txtHrsEnf').val(data.infotran[0].horas_enferm);
							$('#txtCert').val(data.infotran[0].horas_certmedic);
							$('#txtAjuste').val(data.infotran[0].horas_ajuste);
							$('#txtAusencia').val(data.infotran[0].horas_ausen);
							$('#txtAdelanto').val(data.infotran[0].adelanto_vacaciones);
							
							$('#txtRegular').val(data.infotran[0].horas_regular);
							$('#txtFactorReg').val(data.infotran[0].factor_reg);
							$('#txtDomingo').val(data.infotran[0].horas_domingo);
							$('#txtFactorDom').val(data.infotran[0].factor_dom);
							$('#txtFeriado').val(data.infotran[0].horas_feriado);
							$('#txtFactorFer').val(data.infotran[0].factor_fer);
							$('#txtCompens').val(data.infotran[0].horas_compensatorio);
							$('#txtFactorCom').val(data.infotran[0].factor_com);
							$('#txtExtra1').val(data.infotran[0].horas_extra1);
							$('#txtFactorExt1').val(data.infotran[0].factor1);
							$('#txtExtra2').val(data.infotran[0].horas_extra2);
							$('#txtFactorExt2').val(data.infotran[0].factor2);      
							$('#txtExtra3').val(data.infotran[0].horas_extra3);
							$('#txtFactorExt3').val(data.infotran[0].factor3);
							$('#txtExtra4').val(data.infotran[0].horas_extra4);
							$('#txtFactorExt4').val(data.infotran[0].factor4);       
							$('#txtExtra5').val(data.infotran[0].horas_extra5);
							$('#txtFactorExt5').val(data.infotran[0].factor5);
							$('#txtExtra6').val(data.infotran[0].horas_extra6);
							$('#txtFactorExt6').val(data.infotran[0].factor6);      
							$('#txtExtra7').val(data.infotran[0].horas_extra7);
							$('#txtFactorExt7').val(data.infotran[0].factor7);
							$('#txtExtra8').val(data.infotran[0].horas_extra8);
							$('#txtFactorExt8').val(data.infotran[0].factor8);  
							$('#txtExtra9').val(data.infotran[0].horas_extra9);
							$('#txtFactorExt9').val(data.infotran[0].factor9); 
							$('#txtExtra10').val(data.infotran[0].horas_extra10);
							$('#txtFactorExt10').val(data.infotran[0].factor10); 

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


