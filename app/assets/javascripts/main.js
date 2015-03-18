// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
	$('#login-form').on('ajax:success', function(e,data) {  
	    $("#reservation-form").submit();
	}).on("ajax:error", function() {  
	    $("#notice").html("Invalid Email or Password!!!").show();
	});
	$("#restaurant_id").val("");
	$("#reservation_branch_id").val("");
	
});
function populateBranches(val){
	val = val.split("|");
	$("#restaurant_id").val(val[0]);
	if(val==0){
		$("#branch_id").html("");
	}
	else {
		
		$.ajax({url: "/dashboard/restaurants/"+val[1]+"/branches/list", success: function(result){
				var html = "<option value='|UTC|20'>Select One</option>";
				$("#reservation_branch_id").val("");
	            $("#time_zone").attr("readonly",false);
	            $("#time_zone").val("UTC");
	            $("#time_zone").attr("readonly",true);
	            
	            for (i = 0 ;i<result.length;i++){
	            	html = html+"<option value='"+result[i].id +"|"+result[i].time_zone+"|"+result[i].seating_capacity+"'>"+result[i].title+"</option>";
	            }
	            $("#branch_id").html(html);
        	
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
			$('#login-popup').modal('show');
		}
	}
	else if(submission===1) {
		$("#reservation_branch_id").val($(object).closest('tr.branch').data("value"));
		if(signed_in){
			$("#reservation-form").submit();
		}
		else {
			$('#time-slots').modal('hide');
			$('#login-popup').modal('show');
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
			$('#login-popup').modal('show');
		}
	}

	$("#slots td").unbind( "click" );
}
function assignBranchValue(val){
	val = val || "";
	val = val.split("|");
	$("#reservation_branch_id").val(val[0]);
	$("#time_zone").attr("readonly",false);
	$("#time_zone").val(val[1]);
	$("#time_zone").attr("readonly",true);
	limit = parseInt(val[2]);
	
	var html = "";
	for(i=0;i<limit;i++){
		html = html + "<option value='"+(i+1)+"'>"+(i+1)+"</option>";
	}
	$("#reservation_people").html(html);
}
function checkAvailability(id){

	id = id || 0 ;
	val = $("#reservation_branch_id").val();
	people = $("#reservation_people").val();
	date = $("#date").val();
	time = $("#time").val();
	user = $("#reservation_user_id").val();
	
	restaurant = $("#restaurant_id").val();
	restaurant = restaurant.split("|");
	restaurant = restaurant[0];
	$(".datetime-group").removeClass("has-danger");
	$("#submit-button").attr("disabled",true);
	$("table#slots tbody").html("");
	$.ajax({	
			url: "/availability_customer",
			type: "POST",
			data:{"restaurant":restaurant ,"customer":user,"branch" : val,"time":time,"date":date,"people" : people,"id":id,"time_zone" : $("#time_zone").val()},
			error: function(){
				$("#submit-button").attr("disabled",false);
			},
			success: function(result){

				if(result.available && result.user_signed_in){
					$("#submit-button").attr("disabled",false);
		        	$("#notice").html(result.message).show();
		        	$("#submit-button").val("Saving");
		        	$("#reservation-form").submit();
		        	
				}
				else if(result.available && !result.user_signed_in){
					$("#submit-button").attr("disabled",false);
		        	
		        	$('#login-popup').modal('show');
		        	
				}
				else if(!result.available && result.message == "Please Enter A Valid Time" || result.message == "Please Enter A Valid Date"){
						$("#notice").html(result.message).show();
						$(".datetime-group").addClass("has-error");
						$("#submit-button").attr("disabled",false);
				}
				else if(result.branch_slots){
					
					
	        		$("#submit-button").attr("disabled",false);
	        		var html = "<tr><th>Selected Branch</th></tr>";
	        		for(i=0;i<result.time_slots.length;i++){
	        			if(result.time_slots[i].available){
	        				html= html + "<tr><td>"+result.time_slots[i].time_slot+"</td></tr>";
	        			}
	        		}
	        		$("table#slots tbody").html(html);
	        		$("#slots td").unbind( "click" ).click(function(){ setTimeFromSlot($(this).html(),0,this,result.user_signed_in)});
	        		$('#time-slots').modal('show');
				}
				else if(result.restaurant_slots){
					
	        		$("#submit-button").attr("disabled",false);

					var html="";
	        		for(i=0;i<result.time_slots.length;i++){
	        			html = html+"<tr class='branch' data-value = '"+result.time_slots[i].id+"'>";
	        			html = html+"<th>"+result.time_slots[i].title+"</th>";
	        			for(j=0;j<result.time_slots[i].time_slots.length;j++){
		        			if(result.time_slots[i].time_slots[j].available){
		        				html= html + "<td>"+result.time_slots[i].time_slots[j].time_slot+"</td>";
		        			}
		        		}
		        		html = html + "</tr>";
	        		}
	        		$("table#slots tbody").html(html);
	        		$("#slots td").unbind( "click" ).click(function(){ setTimeFromSlot($(this).html(),1,this,result.user_signed_in)});
	        		$('#time-slots').modal('show');
				}
				else if(result.all_slots){
					
	        		$("#submit-button").attr("disabled",false);

					var html="";
					for(x=0;x<result.time_slots.length;x++){
						html=html+"<tr class='restaurant' data-value='"+result.time_slots[x].id+"'><th>"+result.time_slots[x].title+"</th></tr>"
		        		for(i=0;i<result.time_slots[x].time_slots.length;i++){
		        			html = html+"<tr class='branch' data-value='"+result.time_slots[x].time_slots[i].id+"'>";
		        			html = html+"<th>"+result.time_slots[x].time_slots[i].title+"</th>";
		        			for(j=0;j<result.time_slots[x].time_slots[i].time_slots.length;j++){
			        			if(result.time_slots[x].time_slots[i].time_slots[j].available){
			        				html= html + "<td>"+result.time_slots[x].time_slots[i].time_slots[j].time_slot+"</td>";
			        			}
			        		}
			        		html = html + "</tr>";
		        		}
		        	}
	        		$("table#slots tbody").html(html);
	        		$("#slots td").unbind( "click" ).click(function(){ setTimeFromSlot($(this).html(),2,this,result.user_signed_in)});
	        		$('#time-slots').modal('show');
				}
	        	else {
	        		$("#notice").html(result.message).show();
	        		$("#submit-button").attr("disabled",false);
	        	}
	        	
	        }
	    });
	
	
	
}
