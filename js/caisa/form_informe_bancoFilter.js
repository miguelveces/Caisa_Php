$(function() {
    var id=0;
	var infoperiod;
	var numperiod;
	var year;
	function formatDate(dt) {
			var df = dt.split('-');
			var fdate = df[2]+'-'+df[1]+'-'+df[0];
	  return fdate;
	}
	function loadingDates(numperiod,year) {
		$.each(infoperiod, function(i, item) {
			if(item.numero_periodo==numperiod && item.anno_fiscal==year)
			{
				$('#txtDatePay').val(formatDate(item.fecha_pago));
				$('#txtDateD').val(formatDate(item.fecha_inicio));
				$('#txtDateH').val(formatDate(item.fecha_final));
				
			}
			 
		});
	}
	$(function(){
		$('#ddlYearFiscal').on('change', function(){
			year=$(this).val();
			$('#ddlNumberPeriod').empty();
			
			$.each(infoperiod, function(i, item) {
				if(item.anno_fiscal==year)
				{
					 $('#ddlNumberPeriod').append('<option value="'+item.numero_periodo+'">'+item.numero_periodo+'</option>');
				} 
			});
			
			loadingDates($("#ddlNumberPeriod" ).val(),year);
		});
	});
	$(function(){
		$('#ddlNumberPeriod').on('change', function(){
			numperiod=$(this).val();
			loadingDates(numperiod,$("#ddlYearFiscal" ).val());
		});
	});
	
	function url_redirect(options){
                 var $form = $("<form />");
                 
                 $form.attr("action",options.url);
                 $form.attr("method",options.method);
                 $form.attr("target",options.target);
                 for (var data in options.data)
                 $form.append('<input type="hidden" name="'+data+'" value="'+options.data[data]+'" />');
                  
                 $("body").append($form);
                 $form.submit();
    }
             

    $.ajax({
				url: "./bin/form_informe_bancoFilter.php",
				type: "GET",
				cache: false,
                crossDomain: false,
				success: function(data) {
				 
				
						if (data.status == 1)
						{
						    id=data.info[0].id_periodo;
							$('#txtDatePay').val(formatDate(data.info[0].fecha_pago));
							$('#txtDateD').val(formatDate(data.info[0].fecha_inicio));
							$('#txtDateH').val(formatDate(data.info[0].fecha_final));
							
							$('#ddlYearFiscal').append(data.year);
							$('#ddlNumberPeriod').append(data.period);
							infoperiod=data.infoperiods;
							
						}		
				},
				error: function() {
					// Fail message
				},
	})

	$("input,select,textarea").jqBootstrapValidation({
        preventSubmit: true,
        submitError: function($form, event, errors) {
            // something to have when submit produces an error ?
            // Not decided if I need it yet
        },
        submitSuccess: function($form, event) {
            event.preventDefault(); // prevent default submit behaviour
			var yearfiscal =$("select#ddlYearFiscal").val();
			var numberperiod =$("select#ddlNumberPeriod").val();
			var reporttype =$("select#ddlReportType").val();
			var datepay = $("input#txtDatePay").val();
			var dated = $("input#txtDateD").val();
            var dateh = $("input#txtDateH").val();
			if(reporttype==1)
			{
				url_redirect({url: "form_informe_banco.html",
							  method: "get", 
							  target: "_self", 
							  data: {id:id,yearfiscal:yearfiscal,numberperiod:numberperiod,datepay:datepay,dated:dated,dateh:dateh}
							 });
			}
			else if(reporttype==2)
			{
				url_redirect({url: "./bin/pdf_informe_banco.php",
							  method: "get",
							  target: "_blank", 
							  data: {id:id,yearfiscal:yearfiscal,numberperiod:numberperiod,datepay:datepay,dated:dated,dateh:dateh}
							 });
			}
			else
			{
				url_redirect({url: "./bin/txt_informe_banco.php",
							  method: "get",
							  target: "_blank", 
							  data: {id:id,yearfiscal:yearfiscal,numberperiod:numberperiod,datepay:datepay,dated:dated,dateh:dateh}
							 });
			}
	
       
			
        },
        filter: function() {
            return $(this).is(":visible");
        },

    });

});