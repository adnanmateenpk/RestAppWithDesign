// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function populateBranches(val){
	if(val==0){
		$("#branch_id").html("");
		
	}
	else {
		val = val.split("|");
		$.ajax({url: "/dashboard/restaurants/"+val[1]+"/branches/list", success: function(result){
				html = "";
	            for (i = 0 ;i<result.length;i++){
	            	$("#reservation_branch_id").val(result[0].id);
	            	html = html+"<option value='"+result[i].id +"|"+result[i].slug+"|"+val[1]+"'>"+result[i].title+"</option>";
	            }
	            $("#branch_id").html(html);
        	
        }});
	}
	
}
function assignBranchValue(val){
	val = val.split("|");
	$("#reservation_branch_id").val(val[0]);
}
function checkAvailability(object){
	val = $("#reservation_branch_id").val();
	people = $("#reservation_people").val();
	date = $("#date").val();
	time = $("#time").val();
	user = $("#reservation_user_id").val();

	if ((new Date(date.split("-").join("/")+" "+time)) < new Date()) {
		alert("Please Enter A valid Date or time");
	}
	else {
		
		$.ajax({	
				url: "/availability_restaurant",
				type: "POST",
				data:{"customer":user,"branch" : val,"time":time,"date":date,"people" : people },
				done: function(){

				},
				success: function(result){
					if(result.found){
			            $(".form-buttons").html($(".form-buttons").html()+'<input type="submit" value="Create Reservation" name="commit" id="submit-button" style="display:none;">');
						$("#notice").html("Table Available!!!").show();
						$("#submit-button").fadeIn();
		        	}
		        	else {
		        		$("#notice").html("Table Not Available!!!").show();
		        		$("#submit-button").remove();
		        	}
		        	
		        }
		    });
	}
	
	
}
