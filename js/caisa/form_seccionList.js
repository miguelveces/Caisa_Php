$(function() {

	$.ajax({
		url: "./bin/form_seccionList.php",
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
						data.info[i].codigo_seccion,
						data.info[i].nombre_seccion,
						data.info[i].nombre_departamento,
						
						'<a class="btn btn-info" href="form_seccionEdit.html?id='+data.info[i].id_seccion+'"><i class="icon-edit"></i> Modificar</a>'
						]);										
					} // End For
				}		
		},
		error: function() {
			// Fail message
		},
	})
});