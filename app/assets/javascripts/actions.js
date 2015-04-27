var waitForFinalEvent = (function () {
  var timers = {};
  return function (callback, ms, uniqueId) {
    if (!uniqueId) {
      uniqueId = "Don't call this twice without a uniqueId";
    }
    if (timers[uniqueId]) {
      clearTimeout (timers[uniqueId]);
    }
    timers[uniqueId] = setTimeout(callback, ms);
  };
})();
// $(window).resize(function () {

//     waitForFinalEvent(function(){
//       if($(".track4").height()!=$(".handle4").height()){
// 			if($(window).width()>=992){
// 				$(".track4").parent().css("top","30px").css("left",($(".restaurant-logo-container").parent().width()+75) + "px");
// 			}
// 			else {
// 				$(".track4").parent().css("top","30px").css("left",($(".restaurant-logo-container").parent().width()+10) + "px");
			
// 			}
// 			$(".restaurant-logo-container").attr("style","outline: medium none; overflow: hidden;");
// 		}
//     }, 500, "some unique string");
// });
// var initialize = function() {
// 	var r = $.Deferred();
// 	$(".restaurant-logo-container").enscroll({
// 		verticalTrackClass: 'track4',
// 	    verticalHandleClass: 'handle4',
// 	    pollChanges: false
// 	});
// 	$(".reservations").enscroll({
// 		pollChanges: false,
// 		showOnHover: true,
// 	    verticalTrackClass: 'track3',
// 	    verticalHandleClass: 'handle3'
// 	});
// 	$(".restaurant-logo-container,.reservations").attr("style","outline: medium none; overflow: hidden;");
// 	$(".track4").parent().hide();
// 	$(".track3").parent().css("top","0");
// 	  var myLatlng = new google.maps.LatLng(37.7699298, -122.4469157);
// 	  var mapOptions = {
// 	    zoom: 14,
// 	    center: myLatlng
// 	  }
// 	  var mapCanvas =  document.getElementById('map');
// 	  if(mapCanvas!=null){ 

// 		  var map = new google.maps.Map(mapCanvas, mapOptions);

// 		  var marker = new google.maps.Marker({
// 		      position: myLatlng,
// 		      map: map
// 		  });
// 		}
// 	  setTimeout(function () {
// 	    // and call `resolve` on the deferred object, once you're done
// 	    r.resolve();
// 	  }, 2500);
// 	  return r;
  
// }

$(document).ready(function(){

	// initialize().done(function(){
	// 	if($(".track4").height()!=$(".handle4").height()){
	// 		if($(window).width()>=992){
	// 			$(".track4").parent().css("top","30px").css("left",($(".restaurant-logo-container").parent().width()+75) + "px").show();
	// 		}
	// 		else {
	// 			$(".track4").parent().css("top","30px").css("left",($(".restaurant-logo-container").parent().width()+10) + "px").show();
			
	// 		}
	// 		$(".restaurant-logo-container").attr("style","outline: medium none; overflow: hidden;");
	// 	}
	// });
	$('.datepicker').datepicker();
	 $('.timepicker').timepicker({minuteStep: 30,defaultTime: false});
   $(document).ready(function() {

      $('.custom-scroll').enscroll({
        minScrollbarLength: 28,
        verticalTrackClass: 'track3',
        verticalHandleClass: 'handle3',
        addPaddingToPane: false
      });
  });
});

