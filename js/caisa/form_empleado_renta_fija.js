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
    function getInfoEmployee(id) {	
		    $.ajax({
				url: "./bin/form_empleado_renta_fija.php",
				type: "GET",
				data: "id=" + id,
				cache: false,
                crossDomain: false,
				success: function(data) {
				 //alert(data.info[0].nombre_usuario);
						if (data.status == 1)
						{
							
							$('#txtEmployeeNum').val(data.info[0].numero_empleado);
							$('#txtLastNames').val(data.info[0].apellido);
							$('#txtNames').val(data.info[0].nombre);
							$('#ddlGender').append(data.gender);
							$('#ddlStatesCivil').append(data.statescivil);
							$('#ddlStatesEmployee').append(data.statesemployee);
							$('#txtKeyRent').val(data.info[0].clave_renta);
							$('#txtPaymentM').val(data.info[0].forma_pago);
							$('#txtPaymentF').val(data.info[0].frecuencia_pago);
							$('#txtRent').val(data.info.monto_isr);
							$('#txtSociSecu').val(data.info.monto_ss);
							$('#txtEduSecu').val(data.info.monto_se);
							
							
							
							
						}		
				},
				error: function() {
					// Fail message
				},
			})
    }

});