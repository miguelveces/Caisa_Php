$(function() {
var id=getUrlVars()["id"];
var signnum=getUrlVars()["signnum"];
	function formatDate(dt) {
		var fdate="";
			if(dt!="" && dt!="0000-00-00")
			{
				var df = dt.split('-');
			   fdate = df[2]+'-'+df[1]+'-'+df[0];
			}
			
		return fdate;
	}
	function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
	}
	$.ajax({
		url: "./bin/form_descuento_ingreso_empleadoEdit.php",
		type: "GET",
		 data: "signnum=" + signnum,
		cache: false,
        crossDomain: false,
		success: function(data) {
		$('#cancel').attr('href','form_descuento_ingreso_empleadoList.html?id='+ id)
				if (data.status == 1)
				{
					$("#txtSignNum").val(data.info[0].id_descuento_ingreso_empleado);
					$("#txtCustomerNum").val(data.info[0].numero_cliente);
					$("#txtBankAccount").val(data.info[0].numero_cuenta);
					$('#txtEmployeeNum').val(data.infoem[0].numero_empleado);
					$('#txtLastNames').val(data.infoem[0].apellido);
					$('#txtNames').val(data.infoem[0].nombre);
					$('#ddlSeccionDepart').append(data.sectionsdepart);
					$('#ddlDiscountIncome').append(data.discountincome);
					$('select[name="ddlAfectDecember"]').find('option[value="'+data.info[0].afecta_diciembre+'"]').attr("selected",true);
					$("#txtType").val(data.info[0].tipo);
					$("#txtPriority").val(data.info[0].prioridad);
					$("#txtFrequency").val(data.info[0].frecuencia);
					$("#txtAmountperMonth").val(data.info[0].monto_mes);
					$("#txtAmountperPeriod").val(data.info[0].monto_periodo);
					$("#txtAmountOriginal").val(data.info[0].monto_original);
					$("#txtAmountOutstanding").val(data.info[0].monto_pendiente);
					$("#txtAmountUrgent").val(data.info[0].monto_urgente);
					$('#txtDateLastPay').val(formatDate(data.info[0].fecha_ultimo_pago));
					$("#txtQuantityPayments").val(data.info[0].cantidad_pago);
					$("#txtReference").val(data.info[0].referencia);
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
			//var datastring = $("#form_empleado").serialize();
            var signnum = $("input#txtSignNum").val();
            var customernum = $("input#txtCustomerNum").val();
			var bankaccount = $("input#txtBankAccount").val();
			var employeenum = $("input#txtEmployeeNum").val();
			//var lastnames = $("input#txtLastNames").val();
            //var names = $("input#txtNames").val();
			var discountincome = $("select#ddlDiscountIncome").val();
			var afectdecember = $("select#ddlAfectDecember").val();
			var type = $("input#txtType").val();
            var priority = $("input#txtPriority").val();
			var frequency = $("input#txtFrequency").val();
			var amountpermonth = $("input#txtAmountperMonth").val();
			var amountperperiod = $("input#txtAmountperPeriod").val();
			var amountoriginal = $("input#txtAmountOriginal").val();
			var amountoutstanding = $("input#txtAmountOutstanding").val();
			var amounturgent = $("input#txtAmountUrgent").val();
			var datelastpay = formatDate($("input#txtDateLastPay").val());
			var quantitypayments = $("input#txtQuantityPayments").val();
			var reference = $("input#txtReference").val();
			

            //alert(paymentf);
            ////var firstName = name; // For Success/Failure Message
            // Check for white space in name for Success/Fail message
            ////if (firstName.indexOf(' ') >= 0) {
                ////firstName = name.split(' ').slice(0, -1).join(' ');
            ////}
            $.ajax({
                url: "./bin/form_descuento_ingreso_empleadoEdit.php",
                type: "POST",
                data: 
				{
                    signnum:signnum, 
					customernum:customernum,
					bankaccount:bankaccount,
					employeenum:employeenum, 
					//lastnames:lastnames, 
					//names:names, 
					discountincome:discountincome, 
					afectdecember:afectdecember, 
					type:type,
					priority:priority, 
					frequency:frequency, 
					amountpermonth:amountpermonth,
					amountperperiod:amountperperiod,
					amountoriginal:amountoriginal,
					amountoutstanding:amountoutstanding,					
					amounturgent:amounturgent,
					datelastpay:datelastpay,
					quantitypayments:quantitypayments,
					reference:reference
                },
                cache: false,
				crossDomain: false,
                success: function(data) {
				   // Success message
				   //alert(data.status);
					if(data.status == 1)
					{
							$('#success').html("<div class='alert alert-success'>");
							$('#success > .alert-success').append("<strong> Fue registrado correctamente</strong>");
							$('#success > .alert-success').append('</div>');

							//clear all fields
							$('#form_empleado').trigger("reset");
					}
					else
					{
						    $('#success').html("<div class='alert alert-danger'>");
							$('#success > .alert-danger').append("NO se registro ");
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