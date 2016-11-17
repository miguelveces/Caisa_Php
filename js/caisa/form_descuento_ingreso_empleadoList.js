$(function() {
var id=getUrlVars()["id"];

	
	function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
	}
	$.ajax({
		url: "./bin/form_descuento_ingreso_empleadoList.php",
		type: "GET",
		 data: "id=" + id,
		cache: false,
        crossDomain: false,
		success: function(data) {
		$('#nuevo').attr('href','form_descuento_ingreso_empleadoAdd.html?id='+ id)
				//var oTable = $('#DataTables_Table_0').dataTable();  //Initialize the datatable
				//oTable.fnClearTable();
				var oTable = $('#DataTables_Table_0').dataTable( {
                            "bDestroy": true,
                            "bProcessing": true,
                            "bRetrieve": true,
                            "bServerSide": false,
                            "bPaginate": false,
							"bFilter": false,
							"bInfo": false
                        });
				oTable.fnClearTable();
				if (data.status == 1)
				{

				
				 
					for(var i = 0; i < data.info.length; i++) {
						//alert(data.info[i].id_usuarios);
						
						var datadiscountsincome = $.grep(data.discountsincome, function(obj){return obj.id_descuento_ingreso == data.info[i].id_descuento_ingreso});
		
						oTable.fnAddData([
						
						data.info[i].numero_empleado,
						datadiscountsincome[0].cod_descuento_ingreso,
						datadiscountsincome[0].nombre_descuento_ingreso,
						data.info[i].monto_mes,
                        data.info[i].monto_periodo,
                        '<a class="btn btn-info" href="form_descuento_ingreso_empleadoEdit.html?id='+data.info[i].id_empleado+'&signnum='+data.info[i].id_descuento_ingreso_empleado+'"><i class="icon-edit"></i> Modificar</a>'
						]);								
					} // End For 

				}		
		},
		error: function() {
			// Fail message
		},
	})
});