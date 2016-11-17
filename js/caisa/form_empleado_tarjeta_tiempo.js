$(function() {

    var id=getUrlVars()["id"];
	
	//$('#pleaseWaitDialog').modal('show');
	function getUrlVars() {
			var vars = {};
			var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
			vars[key] = value;
			});
		  return vars;
	}
	function formatDate(dt) {
				var df = dt.split('-');
				var fdate = df[2]+'-'+df[1]+'-'+df[0];
		  return fdate;
	}
	function formatDay(str) {
		 var replace = new Array("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"); 
		 var by = new Array("Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"); 
			for (var i=0; i<replace.length; i++) { 
				str = str.replace(replace[i], by[i]); 
				} 
		return str; 
	}
	function addTarjetaTiempo(idE) {
		$('#pleaseWaitDialog').modal('show');
		$.ajax({
			url: "./bin/form_empleado_tarjeta_tiempoAdd.php",
			type: "GET",
			 data: "id=" + idE,
			cache: false,
			crossDomain: false,
			success: function(data) {
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
				if (data.status == 1){
							//$("#txtSignNum").val(data.info[0].id_descuento_ingreso_empleado);
							//$("#txtCustomerNum").val(data.info[0].numero_cliente);
							//$("#txtBankAccount").val(data.info[0].numero_cuenta);
							$("#txtPeriod").val(data.period[0].numero_periodo);
							$('#txtDateD').val(formatDate(data.period[0].fecha_inicio));
							$('#txtDateH').val(formatDate(data.period[0].fecha_final));
							$('#txtEmployeeNum').val(data.info[0].numero_empleado);
							$('#txtLastNames').val(data.info[0].apellido);
							$('#txtNames').val(data.info[0].nombre);
							
							for(var i = 0; i < data.workingday.length; i++) {
								//alert(data.info[i].id_usuarios);
								oTable.fnAddData([
								//formatDate(data.workingday[i].fecha),
								data.workingday[i].fecha,
								formatDay(data.workingday[i].dia),
								(data.workingday[i].laboro === 0 ? 'N' : 'S'),
								data.workingday[i].ausencia,
								data.workingday[i].tipo,
								data.workingday[i].codigo,
								data.workingday[i].codigo_jornada,
								data.workingday[i].com,
								data.workingday[i].hora_entra,
								data.workingday[i].hora_sale,
								data.workingday[i].horas_regulares,
								data.workingday[i].horas_extras,
								'<a  class="btn btn-info" href="form_empleado_tarjeta_tiempoEdit.html?id='+id+'&idworkingdayemployee='+data.workingday[i].id_jornada_empleado+'"><i class="icon-edit"></i>Modificar</a>'
								]);	
					
							}
							$('#pleaseWaitDialog').modal('hide');
				}
			},
			error: function() {
				// Fail message
			},
		})
		//return data; 
	}
	    //event.preventDefault(); 
		
		$.ajax({
			url: "./bin/form_empleado_tarjeta_tiempo.php",
			type: "GET",
			 data: "id=" + id,
			cache: false,
			crossDomain: false,
			success: function(data) {
			
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
						addTarjetaTiempo(id)
					}
					else
					{
						//$("#txtSignNum").val(data.info[0].id_descuento_ingreso_empleado);
						//$("#txtCustomerNum").val(data.info[0].numero_cliente);
						//$("#txtBankAccount").val(data.info[0].numero_cuenta);
						$("#txtPeriod").val(data.period[0].numero_periodo);
						$('#txtDateD').val(formatDate(data.period[0].fecha_inicio));
						$('#txtDateH').val(formatDate(data.period[0].fecha_final));
						$('#txtEmployeeNum').val(data.info[0].numero_empleado);
						$('#txtLastNames').val(data.info[0].apellido);
						$('#txtNames').val(data.info[0].nombre);
						
						for(var i = 0; i < data.workingday.length; i++) {
							//alert(data.info[i].id_usuarios);
							oTable.fnAddData([
							//formatDate(data.workingday[i].fecha),
							data.workingday[i].fecha,
							formatDay(data.workingday[i].dia),
							(data.workingday[i].laboro === 0 ? 'N' : 'S'),
							data.workingday[i].ausencia,
							data.workingday[i].tipo,
							data.workingday[i].codigo,
							data.workingday[i].codigo_jornada,
							data.workingday[i].com,
							data.workingday[i].hora_entra,
							data.workingday[i].hora_sale,
							data.workingday[i].horas_regulares,
							data.workingday[i].horas_extras,
							'<a  class="btn btn-info" href="form_empleado_tarjeta_tiempoEdit.html?id='+id+'&idworkingdayemployee='+data.workingday[i].id_jornada_empleado+'"><i class="icon-edit"></i>Modificar</a>'
							]);										
						
						}	
						// End For
						//$('#pleaseWaitDialog').modal('hide');
						
						/*$('#ddlSeccionDepart').append(data.sectionsdepart);
						$('#ddlDiscountIncome').append(data.discountincome);
						$('select[name="ddlAfectDecember"]').find('option[value="'+data.info[0].afecta_diciembre+'"]').attr("selected",true);

						
						$("#txtAmountperMonth").val(data.info[0].monto_mes);
						$("#txtAmountperPeriod").val(data.info[0].monto_periodo);
						$("#txtAmountUrgent").val(data.info[0].monto_urgente);
						$("#txtReference").val(data.info[0].referencia);*/
					}		
			},
			error: function() {
				// Fail message
			},
		})
	
	
});