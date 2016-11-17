$(function() {

	$.ajax({
		url: "./bin/form_usuarioList.php",
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
						data.info[i].nombre_usuario,
						data.info[i].nombre_rol,
						((data.info[i].nombre_estado_usuario == 'ACTIVO') ? '<span class="label label-success">'+ data.info[i].nombre_estado_usuario +'</span>' : '<span class="label">'+ data.info[i].nombre_estado_usuario +'</span>'),
						'<a class="btn btn-info" href="form_usuarioEdit.html?id='+data.info[i].id_usuario+'"><i class="icon-edit"></i> Modificar</a>'
						]);										
					} // End For

				}		
		},
		error: function() {
			// Fail message
		},
	})
});