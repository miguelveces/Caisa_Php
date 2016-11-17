$(function() {

    //var id=getUrlVars()["id"]; 
	//var numberperiod=getUrlVars()["numberperiod"];
	//var datepay=getUrlVars()["datepay"];

	//getInfoEmployee(id);
	/*function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
	}*/
	$.ajax({
		url: "./bin/form_carga_datos_relojList.php",
		type: "GET",
		cache: false,
        crossDomain: false,
		success: function(data) {
				var oTable = $('#DataTables_Table_0').dataTable();  //Initialize the datatable
				oTable.fnClearTable();
				if (data.status == 1)
				{
				//console.log(data.info[306][0]);
				//alert(data.info[306][0]);
					for(var i = 1; i < data.info.length-1; i++) {
						//console.log(i);
						//alert(data.info[306][0]);
						//if(data.info[0][0])
						//{
							oTable.fnAddData([
							data.info[i][0],
							data.info[i][1],
							data.info[i][2],
							data.info[i][3],
							data.info[i][4],
							data.info[i][5],
							data.info[i][6],
							data.info[i][7]
							]);
						//}												
					} // End For
					
				}		
		},
		error: function() {
			// Fail message
		},
	})
});
