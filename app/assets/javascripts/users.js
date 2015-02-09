// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){

		$('.ajax-form').on('ajax:success', function() {  
	        $(this).closest("tr").find(".ajax-button").attr("disabled",false)
	        $(this).find(".ajax-button").attr("disabled",true)

		}); 
})