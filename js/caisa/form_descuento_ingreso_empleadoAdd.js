$(function() {
var id=getUrlVars()["id"];

	
	function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
	}
	$.ajax({
		url: "./bin/form_descuento_ingreso_empleadoAdd.php",
		type: "GET",
		 data: "id=" + id,
		cache: false,
        crossDomain: false,
		success: function(data) {
		$('#cancel').attr('href','form_descuento_ingreso_empleadoList.html?id='+ id)
				if (data.status == 1)
				{

					$('#txtEmployeeNum').val(data.info[0].numero_empleado);
					$('#txtLastNames').val(data.info[0].apellido);
					$('#txtNames').val(data.info[0].nombre);
					$('#ddlSeccionDepart').append(data.sectionsdepart);
					$('#ddlDiscountIncome').append(data.discountincome);
					$('#txtType').val(3);
					$('#txtPriority').val(4);


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
			//var amountperperiod = $("input#txtAmountperPeriod").val();
			var amountoriginal = $("input#txtAmountOriginal").val();
			//var amountoutstanding = $("input#txtAmountOutstanding").val();
			var amounturgent = $("input#txtAmountUrgent").val();
			var reference = $("input#txtReference").val();
			

            //alert(amountpermonth); 
            ////var firstName = name; // For Success/Failure Message
            // Check for white space in name for Success/Fail message
            ////if (firstName.indexOf(' ') >= 0) {
                ////firstName = name.split(' ').slice(0, -1).join(' ');
            ////}
            $.ajax({
                url: "./bin/form_descuento_ingreso_empleadoAdd.php",
                type: "POST",
                data: 
				{
                    id:id, 
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
					//amountperperiod:amountperperiod,
					amountoriginal:amountoriginal,
					//amountoutstanding:amountoutstanding,					
					amounturgent:amounturgent,
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