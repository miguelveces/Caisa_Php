$(function() {
   
	$.ajax({
		url: "./bin/menu.php",
		type: "GET",
		cache: false,
        crossDomain: false,
		success: function(data) {
					 //alert(data.status);
				if (data.status == 1)
				{
					$("#IncludeMenu").append(data.info);
					
				/* ---------- Add class .active to current link  ---------- */
					$('ul.main-menu li a').each(function(){
						
							if($(this)[0].href==String(window.location)) {
								
								$(this).parent().addClass('active');
								
							}
							
					
					});
					
					$('ul.main-menu li ul li a').each(function(){
						
							
							
							if($(this)[0].href==String(window.location)) {

								$(this).parent().addClass('active');
								//$(this).parent().parent().show();

								
							}
							else{
								
								
							 $(this).parent().parent().hide();
							
								
							}
					
					});

					/* ---------- Submenu  ---------- */

					$('.dropmenu').click(function(e){

						e.preventDefault();

						$(this).parent().find('ul').slideToggle();

					});
						
				}
					
						
		},
		error: function() {
			// Fail message
		},
	})
});
