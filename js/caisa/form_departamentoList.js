$(function() {

	$.ajax({
		url: "./bin/form_departamentoList.php",
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
						data.info[i].codigo_departamento,
						data.info[i].nombre_departamento,
						data.info[i].nombre_departamento,
						'<a class="btn btn-info" href="form_departamentoEdit.html?id='+data.info[i].id_departamento+'"><i class="icon-edit"></i> Modificar</a>'
						]);										
					} // End For
				}		
		},
		error: function() {
			// Fail message
		},
	})
});