$(function() {

	$.ajax({
		url: "./bin/form_descuento_ingresoList.php",
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
						data.info[i].cod_descuento_ingreso,
						data.info[i].nombre_descuento_ingreso,
                                                data.info[i].tipo,
                                                data.info[i].numero_cuenta,
						'<a class="btn btn-info" href="form_descuento_ingresoEdit.html?id='+data.info[i].id_descuento_ingreso+'"><i class="icon-edit"></i> Modificar</a>'
						]);										
					} // End For

				}		
		},
		error: function() {
			// Fail message
		},
	})
});