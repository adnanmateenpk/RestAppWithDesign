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
	$('#branch-form').submit(function(){
		if($("#hours_open").val()==$("#hours_close").val() && $("#mins_open").val()==$("#mins_close").val() && $("#meri_open").val()==$("#meri_close").val()){
			$("p.alert").html("Opening And Closing Time Cannot be equal");
			return false;
		}
		
	})
});
