$(function() {

	$.ajax({
		url: "./bin/form_dia_feriadoList.php",
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
						data.info[i].fecha_dia_feriado,
						data.info[i].celebracion,
						'<a class="btn btn-info" href="form_dia_feriadoEdit.html?id='+data.info[i].id_dia_feriado+'"><i class="icon-edit"></i> Mofificar</a>'
						]);										
					} // End For

				}		
		},
		error: function() {
			// Fail message
		},
	})
});