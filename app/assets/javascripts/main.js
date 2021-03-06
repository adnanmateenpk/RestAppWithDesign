// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
	
	// $('#login-form').on('ajax:success', function(e,data) {  
	// 	showNotice("Creating Reservation");
	// 	$('#loginFormRemote .message').html("");
	//     $("#reservation-form").submit();
	// }).on("ajax:error", function() {  
	//     $('#loginFormRemote .message').html("Invalid Username/Password");
	//     $('#loginFormRemote').modal('show');
	// });
	$("#restaurant_id").val("");
	$("#reservation_branch_id").val("");
	
});
function populateBranches(val,object){
	$("img.selected").removeClass("selected").addClass("disabled");
	$(object).addClass("selected");
	
	val = val.split("|");
	$("#restaurant_id").val(val[0]);
	if(val==0){
		$("#branch_id").html("");
	}
	else {
		
		$.ajax({url: "/dashboard/restaurants/"+val[1]+"/details/list", success: function(result){
				var html = "";
				$("#reservation_branch_id").val("");
	            $("#time_zone").attr("readonly",false);
	            $("#time_zone").val("UTC");
	            $("#time_zone").attr("readonly",true);
	            assignBranchValue(result);
		        
	            
        		
        }});
	}
	
}
function setTimeFromSlot(time,submission,object,signed_in){
	var t1= time.split(" ");
	var t2 = t1[0].split(":");
	var t3= t2[0]+":"+t2[1];
	time=t3+ " " + t1[1];
	$("#time").val(time);
	console.log(signed_in);
	if(submission===0){
		if(signed_in){
			$("#reservation-form").submit();
		}
		else {
			$('#time-slots').modal('hide');
			$('#loginFormRemote').modal('show');
		}
	}
	else if(submission===1) {
		$("#reservation_branch_id").val($(object).closest('tr.branch').data("value"));
		if(signed_in){
			$("#reservation-form").submit();
		}
		else {
			$('#time-slots').modal('hide');
			$('#loginFormRemote').modal('show');
		}
	}
	else if(submission===2) {
		$("#restaurant_id").val($(object).closest('tr.restaurant').data("value"));
		$("#reservation_branch_id").val($(object).closest('tr.branch').data("value"));
		if(signed_in){
			$("#reservation-form").submit();
		}
		else {
			$('#time-slots').modal('hide');
			$('#loginFormRemote').modal('show');
		}
	}

	$("#slots td").unbind( "click" );
}
function assignBranchValue(val){
	
	
	$("#reservation_branch_id").val(val.branches[0].id);
	$("#time_zone").attr("readonly",false);
	$("#time_zone").val(val.branches[0].time_zone);
	$("#time_zone").attr("readonly",true);
	limit = val.seating;
	
	var html = "<option value=''>Numero de Personas</option>";
	for(i=0;i<limit.length;i++){
		html = html + "<option value='"+limit[i]+"'>"+limit[i]+"</option>";
	}
	$("#reservation_people").html(html);
	
}
function checkAvailability(id){	
	
	id = id || 0 ;
	val = $("#reservation_branch_id").val();
	people = $("#reservation_people").val();
	date = $("#date").val();
	time = $("#time-select").val();
	user = $("#reservation_user_id").val();
	var $btn = $("#submit-button").button('loading');
	restaurant = $("#restaurant_id").val();
	restaurant = restaurant.split("|");
	restaurant = restaurant[0];
	$("table#slots tbody").html("");
	$.ajax({	
			url: "/availability_customer",
			type: "POST",
			data:{"restaurant":restaurant ,"customer":user,"branch" : val,"time":time,"date":date,"people" : people,"id":id,"time_zone" : $("#time_zone").val()},
			error: function(xhr, ajaxOptions, thrownError){
				$btn.button('reset');
				location.href = "/";
			},
			success: function(result){

				if(result.available && result.user_signed_in){
					$btn.button('reset');
					showNotice(result.message);
					$("#table_id").val(result.table);
		        	$("#reservation-form").submit();
		        	
		        	
				}
				else if(result.available && !result.user_signed_in){
					
		        	$btn.button('reset');
		        	$("#table_id").val(result.table);
		        	$('#loginForm').modal('show');
		        	
		        	
				}
				else {
	        		showNotice(result.message);
	        		$btn.button('reset');
	        	}
	        	
	        }
	    });
	
	
	
}
function showNotice(message){
	$("#reservationNotice .modal-body").html(message);
	$("#reservationNotice").modal("show");
}

