$(function() {

	$.ajax({
		url: "./bin/form_jornadaList.php",
		type: "GET",
		cache: false,
        crossDomain: false,
		success: function(data) {
				var oTable = $('#DataTables_Table_0').dataTable();  //Initialize the datatable
				oTable.fnClearTable();
				if (data.status == 1)
				{

					for(var i = 0; i < data.info.length; i++) {
						//alert(data.info[i].descripcion);
						oTable.fnAddData([
						data.info[i].codigo_jornada,
						data.info[i].descripcion,
						data.info[i].hora_inicia,
						data.info[i].hora_termina,
						data.info[i].total_horas,					  
						data.info[i].paga,
						data.info[i].turno,
						'<a title="Modificar" class="btn btn-info" href="form_jornadaEdit.html?id='+data.info[i].id_jornada+'"><i class="icon-edit"></i> Modificar</a>'
						]);										
					} // End For

				}		
		},
		error: function() {
			// Fail message
		},
	})
});