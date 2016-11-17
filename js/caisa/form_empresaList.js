$(function() {

	$.ajax({
		url: "./bin/form_empresaList.php",
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
						data.info[i].id_empresa,
						data.info[i].nombre_empresa,
					    ((data.info[i].codigo_actividad == '1') ? '<span class="label label-success">ACTIVO</span>' : '<span class="label">INACTIVO</span>'),
						data.info[i].representante_legal,
						'<a  class="btn btn-info" href="form_empresaEdit.html?id='+data.info[i].id_empresa+'"><i class="icon-edit"></i> Modificar </a>' 
						]);										
					} // End For
					/*for(var j = 0; j < 1; i++) {
						//alert(data.info[i].id_usuarios);
						oTable.fnAddData([
						data.info[i].id_empresa,
						data.info[i].nombre_empresa,
					    ((data.info[i].codigo_actividad == '1') ? '<span class="label label-success">ACTIVO</span>' : '<span class="label">INACTIVO</span>'),
						data.info[i].representante_legal,
						'<a title="Modificar" class="btn btn-info" href="form_empresaEdit.html?id='+data.info[i].id_empresa+'"><i class="icon-edit"></i></a>' 
						]);										
					}*/ // End For
					
					//var table = $('#example').DataTable( {scrollX: "100%"} );
								//$( table.table().footer() ).addClass( 'highlight' );
				}		
		},
		error: function() {
			// Fail message
		},
	})
	

});