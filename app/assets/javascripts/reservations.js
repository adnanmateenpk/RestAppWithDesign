// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
	$('.reservation_row').on('ajax:success', function() {  
	        $(this).closest('td').prevAll('td.status').html("Cancelled")
	        $(this).fadeOut("slow",function(){
	        	$(this).remove();
	        	
	        })
	});
	
});
function populateBranches(val){
	$("#reservation_branch_id").val("");
	val = val || "";
	if(val==0){
		$("#branch_id").html("");
	}
	else {
		val = val.split("|");
		$.ajax({url: "/dashboard/restaurants/"+val[1]+"/branches/list", success: function(result){
				html = "<option value='|UTC|20'>Select One</option>";
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
function assignBranchValue(val){
	val = val || "";
	val = val.split("|");
	$("#reservation_branch_id").val(val[0]);
	$("#time_zone").attr("readonly",false);
	$("#time_zone").val(val[1]);
	$("#time_zone").attr("readonly",true);
	limit = parseInt(val[2]);
	
	html = "";
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
	time = $("#hours").val()+":"+$("#mins").val()+" "+$("#meri").val();
	user = $("#reservation_user_id").val();
	prev = $("#submit-button").val();
	restaurant = $("#restaurant_id").val();
	restaurant = restaurant.split("|");
	restaurant = restaurant[0];
	$("#submit-button").val("Checking Availability").attr("disabled",true);
	$("table#slots tbody").html("");
	$.ajax({	
			url: "/availability_restaurant",
			type: "POST",
			data:{"restaurant":restaurant ,"customer":user,"branch" : val,"time":time,"date":date,"people" : people,"id":id,"time_zone" : $("#time_zone").val()},
			error: function(){
				$("#submit-button").val(prev).attr("disabled",false);
			},
			success: function(result){
				if(result.available){
		        	$("#notice").html(result.message).show();
		        	$("#submit-button").val("Saving");
		        	$("#reservation-form").submit();
				}
				else if(result.branch_slots){
					
					$("#notice").html(result.message).show();
	        		$("#submit-button").val(prev).attr("disabled",false);
	        		html = "<tr><th>Available Time Slots</th></tr>";
	        		for(i=0;i<result.time_slots.length;i++){
	        			if(result.time_slots[i].available){
	        				html= html + "<tr><td>"+result.time_slots[i].time_slot+"</td></tr>";
	        			}
	        		}
	        		$("table#slots tbody").html(html);
				}
				else if(result.restaurant_slots){
					$("#notice").html(result.message).show();
	        		$("#submit-button").val(prev).attr("disabled",false);

					html="";
	        		for(i=0;i<result.time_slots.length;i++){
	        			html = html+"<tr>";
	        			html = html+"<th>"+result.time_slots[i].title+"</th>";
	        			for(j=0;j<result.time_slots[i].time_slots.length;j++){
		        			if(result.time_slots[i].time_slots[j].available){
		        				html= html + "<td>"+result.time_slots[i].time_slots[j].time_slot+"</td>";
		        			}
		        		}
		        		html = html + "</tr>";
	        		}
	        		$("table#slots tbody").html(html);
				}
	        	else {
	        		$("#notice").html(result.message).show();
	        		$("#submit-button").val(prev).attr("disabled",false);
	        	}
	        	
	        }
	    });
	
	
	
}
