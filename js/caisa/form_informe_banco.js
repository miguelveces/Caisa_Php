$(function() {

    var id=getUrlVars()["id"]; 
	var numberperiod=getUrlVars()["numberperiod"];
	var datepay=getUrlVars()["datepay"];

	//getInfoEmployee(id);
	function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
	}
	$.ajax({
		url: "./bin/form_informe_banco.php",
		type: "GET",
		data: "id=" + id,
		cache: false,
        crossDomain: false,
		success: function(data) {
				var oTable = $('#DataTables_Table_0').dataTable();  //Initialize the datatable
				oTable.fnClearTable();
				if (data.status == 1)
				{
					for(var i = 0; i < data.info.length; i++) {
						//alert(data.info[i].id_usuarios);
						oTable.fnAddData([
						data.info[i].numero_empleado,
						data.info[i].cedula_empleado,
						data.info[i].numero_cuenta,
						data.info[i].id_tipo_cuenta,
						data.info[i].nombre_empleado,
						data.info[i].apellido_empleado,
						data.info[i].salario_neto,
						'REF*TXT** PERIODO DE PAGO # '+numberperiod+' '+datepay
						]);										
					} // End For
					
				}		
		},
		error: function() {
			// Fail message
		},
	})
});
