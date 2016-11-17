$(function() {

	$.ajax({
		url: "./bin/form_empleado_calculo_planilla_regular.php",
		type: "GET",
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
						data.info[i].nombre,
						data.info[i].apellido,
						data.info[i].cedula,
						data.info[i].seguro_social,
						'<a class="btn btn-success" href="form_empleado_tarjeta_tiempo.html?id='+data.info[i].id_empleado+'"><i class="icon-plus"></i></a>',
						'<a class="btn btn-success" href="form_empleado_renta_fija.html?id='+data.info[i].id_empleado+'"><i class="icon-plus"></i></a>'
						
						]);										
					} // End For

				}		
		},
		error: function() {
			// Fail message
		},
	})
});