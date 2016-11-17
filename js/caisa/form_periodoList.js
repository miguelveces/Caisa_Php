$(function() {

	$.ajax({
		url: "./bin/form_periodoList.php",
		type: "GET",
		cache: false,
        crossDomain: false,
		success: function(data) {
		
				var oTable = $('#DataTables_Table_0').dataTable();  //Initialize the datatable
				oTable.fnClearTable();
				if (data.status == 1)
				{
					oTable.fnSort( [ [2,'desc'],[6,'desc'] ] );
					for(var i = 0; i < data.info.length; i++) {
						//alert(data.info[i].descripcion);
						oTable.fnAddData([
						data.info[i].anno_fiscal,
						data.info[i].numero_periodo,
						data.info[i].fecha_pago,					  
						data.info[i].fecha_inicio,
						data.info[i].fecha_final,
						((data.info[i].estatus == '1') ? '<span class="label label-success">ACTUAL</span>' : '<span class="label">ANTERIOR</span>'),
						'<a href="#"  data-id="'+data.info[i].id_periodo+'" class="'+((data.info[i].estatus == '1') ? "btn btn-lg btn-danger disabled" : "btn btn-lg btn-danger")+'" data-toggle="modal" data-target="#IncludeModal"><i class="icon-trash"></i> Eliminar</a>'
						
						]);										
					} // End For
						
				
				
				
				
				
				}
						
		},
		error: function() {
			// Fail message
		},
	});
	
		
	$(document).on("click","a",function(e){
	 deleteid = $(this).attr("data-id");
	  $('#IncludeModal').on('shown.bs.modal', function(event) {  
		  $(event.currentTarget).find('#lbl_title').replaceWith('<h2 id="lbl_title"><strong>Eliminar Periodo</strong></h2>');
		  $(event.currentTarget).find('#lbl_body').replaceWith('<h3 id="lbl_body"><span>¿Estás seguro de borrar?</span></h3>');		  
		  $(event.currentTarget).find('#btn-ok').attr('href','form_periodoDelete.html?id='+deleteid);
	  });
	});
});