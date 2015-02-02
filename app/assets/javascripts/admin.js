$(document).ready(function(){

	$('.delete_row').on('ajax:success', function() {  
	        $(this).closest('tr').fadeOut("slow",function(){
	        	$(this).remove();
	        	i=1;
		        $(".position").each(function(){
		        	$(this).html(i);
		        	i++;
		        })
	        })

	}); 
	$('.remove_image').on('ajax:success', function() {  
		
	        $("#featured_image").fadeOut("slow",function(){
	        	$(this).remove();
	        	
	        })

	});
});
