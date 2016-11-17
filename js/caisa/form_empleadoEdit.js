$(function() {
    var id=getUrlVars()["id"];

	getInfoEmployee(id);
	function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
	}
	function formatDate(dt) {
		var fdate="";
			if(dt!="" && dt!="0000-00-00")
			{
				var df = dt.split('-');
			   fdate = df[2]+'-'+df[1]+'-'+df[0];
			}
			
		return fdate;
	}
    function getInfoEmployee(id) {	
		    $.ajax({
				url: "./bin/form_empleadoEdit.php",
				type: "GET",
				data: "id=" + id,
				cache: false,
                crossDomain: false,
				success: function(data) {
				 //alert(data.info[0].nombre_usuario);
						if (data.status == 1)
						{
							
							$('#txtEmployeeNum').val(data.info[0].numero_empleado);
							$('#txtIdentityCardNum').val(data.info[0].cedula);
							$('#txtSociSecuNum').val(data.info[0].seguro_social);
							$('#txtLastNames').val(data.info[0].apellido);
							$('#txtNames').val(data.info[0].nombre);
							$('#ddlGender').append(data.gender);
							$('#ddlNationality').append(data.nationality);
							$('#ddlStatesCivil').append(data.statescivil);
							$('#txtDateBirth').val(formatDate(data.info[0].fecha_nacimiento));
							$('#txtTypeBlood').val(data.info[0].tipo_sangre);
							$('#ddlStatesEmployee').append(data.statesemployee);
							$('#ddlSeccionDepart').empty();
							$('#ddlSeccionDepart').append(data.sectionsdepart);
							$('#ddlSeccionDepart').trigger('liszt:updated');
							$('#ddlPosition').append(data.position);
							$('#txtBaseHours').val(data.info[0].horas_x_periodo);
							$('#txtRatHours').val(data.info[0].rata_x_hora);
							$('#txtSalary').val(data.info[0].salario);
							$('#txtDateContract').val(formatDate(data.info[0].fecha_venc_contrato));
							$('#txtDateCarnet').val(formatDate(data.info[0].fecha_venc_carnet));
							$('select[name="ddlPayment"]').find('option[value="'+data.info[0].pago_efectivo+'"]').attr("selected",true);
							$('select[name="ddlSyndicate"]').find('option[value="'+data.info[0].sindicato+'"]').attr("selected",true);
							$('#txtKeyRent').val(data.info[0].clave_renta);
							$('#txtPaymentM').val(data.info[0].forma_pago);
							$('#txtPaymentF').val(data.info[0].frecuencia_pago);
							$('#txtDateAdmission').val(formatDate(data.info[0].fecha_ingreso));
							$('#txtDateHolidays').val(formatDate(data.info[0].fecha_prox_vacaciones));
							$('#txtDateTermination').val(formatDate(data.info[0].fecha_terminacion));
							$('select[name="ddlISR"]').find('option[value="'+data.info[0].isr_gasto+'"]').attr("selected",true);
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
			//var datastring = $("#form_empleado").serialize();
            var employeenum = $("input#txtEmployeeNum").val();
            var identitycardnum = $("input#txtIdentityCardNum").val();
			var socisecunum = $("input#txtSociSecuNum").val();
			var lastnames = $("input#txtLastNames").val();
            var names = $("input#txtNames").val();
			var gender = $("select#ddlGender").val();
			var nationality = $("select#ddlNationality").val();
			var statescivil = $("select#ddlStatesCivil").val();
			var datebirth = formatDate($("input#txtDateBirth").val());
            var typeblood = $("input#txtTypeBlood").val();
			var statesemployee = $("select#ddlStatesEmployee").val();
			var secciondepart = $("select#ddlSeccionDepart").val();
			var position = $("select#ddlPosition").val();
			var basehours = $("input#txtBaseHours").val();
			var rathours = $("input#txtRatHours").val();
			var salary = $("input#txtSalary").val();
			var datecontract = formatDate($("input#txtDateContract").val());
			var datecarnet = formatDate($("input#txtDateCarnet").val());
			var payment = $("select#ddlPayment").val();
			var syndicate = $("select#ddlSyndicate").val();
			var keyrent = $("input#txtKeyRent").val();
			var paymentm = $("input#txtPaymentM").val();
			var paymentf = $("input#txtPaymentF").val();
			var dateadmission = formatDate($("input#txtDateAdmission").val());
			var dateholidays = formatDate($("input#txtDateHolidays").val());
			var datetermination = formatDate($("input#txtDateTermination").val());
			var isr = $("select#ddlISR").val();

            //alert(paymentf);
            ////var firstName = name; // For Success/Failure Message
            // Check for white space in name for Success/Fail message
            ////if (firstName.indexOf(' ') >= 0) {
                ////firstName = name.split(' ').slice(0, -1).join(' ');
            ////}
            $.ajax({
                url: "./bin/form_empleadoEdit.php",
                type: "POST",
                data: 
				{
                    id:id, 
					employeenum:employeenum, 
					identitycardnum:identitycardnum,
					socisecunum:socisecunum,
					lastnames:lastnames, 
					names:names, 
					gender:gender, 
					nationality:nationality, 
					statescivil:statescivil,
					datebirth:datebirth, 
					typeblood:typeblood, 
					statesemployee:statesemployee,
					secciondepart:secciondepart,					
					position:position,
					basehours:basehours,
					rathours:rathours,
					salary:salary, 
					datecontract:datecontract, 
					datecarnet:datecarnet, 
					payment:payment, 
					syndicate:syndicate, 
					keyrent:keyrent, 
					paymentm:paymentm, 
					paymentf:paymentf, 
					dateadmission:dateadmission, 
					dateholidays:dateholidays, 
					datetermination:datetermination,
					isr:isr
                },
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.status);
					if(data.status == 1)
					{
							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong>El Empleado fue registrado correctamente</strong>");
							$('#success > .alert-success').append('</div>');

							//clear all fields
							$('#form_empleado').trigger("reset");
					}
					else
					{
						    $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("NO se registro el Empleado");
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