$(function() {

	$.ajax({
		url: "./bin/form_empleado_tarjeta_tiempoList.php",
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
						'<a class="btn btn-primary" href="form_empleado_tarjeta_tiempo.html?id='+data.info[i].id_empleado+'"><i class="icon-zoom-in"></i> Ver</a>'
						
						
						]);										
					} // End For

				}		
		},
		error: function() {
			// Fail message
		},
	})
});