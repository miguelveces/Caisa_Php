$(function() {

	$.ajax({
		url: "./bin/form_empleadoList.php",
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
						'<a class="btn btn-inverse" href="form_descuento_ingreso_empleadoList.html?id='+data.info[i].id_empleado+'"><i class="icon-list"></i> Listar</a>',
						'<a class="btn btn-success" href="form_cuenta_banco_empleado.html?id='+data.info[i].id_empleado+'"><i class="icon-plus"></i> Agregar</a>',
						'<a class="btn btn-primary" href="form_empleado_renta_fija.html?id='+data.info[i].id_empleado+'"><i class="icon-zoom-in"></i> Ver</a>',
						data.info[i].numero_empleado,
						data.info[i].nombre,
						data.info[i].apellido,
						data.info[i].cedula,
						'<a class="btn btn-info" href="form_empleadoEdit.html?id='+data.info[i].id_empleado+'"><i class="icon-edit"></i>Modificar</a>'
						
						]);										
					} // End For
					 
				}		
		},
		error: function() {
			// Fail message
		},
	})
});