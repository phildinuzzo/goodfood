
// var lat_and_lng = "37.7841804,-122.39427649999999"

function onPositionUpdate(position)
  {
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;
    // var lat_and_lng = (lat + "," + lng);
    // alert("Current position: " + lat + " " + lng);
  }

  if(navigator.geolocation)
    navigator.geolocation.getCurrentPosition(onPositionUpdate);
  else
    console.log("no geolocation");

    // APPEND ERROR TO INDEX PAGE



// var test = $.getJSON( "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat_and_lng + "&sensor=true")

// var street_num = JSON.parse(test.responseText)

    // console.log(street_num);
    // console.log(test);




      // function getLocation()
      //   {
      //   if (navigator.geolocation)
      //     {
      //     navigator.geolocation.getCurrentPosition(showPosition, error);
      //     }
      //   else{alert("Geolocation is not supported by this browser.");}
      //   }
      // function showPosition(position)
      //   {
      //   alert("Latitude: " + position.coords.latitude +
      //   "<br>Longitude: " + position.coords.longitude);
      //   }
      //  function error(data)
      //   {
      //   alert(data);
      //   }



// $(document).ready(function(){

// $('#address_search').on('click submit', function(event){
//       event.preventDefault();
//       var input = $('input').val();
//       $.ajax({
//         url:
//         method: 'get',
//         dataType: 'jsonp',
//         success: function(results){
//           $('h3').removeClass('hidden');
//           $('#listings').html('');
//           var r = results.Search;

//           } // End success
//       }); // End Ajax
//     }); // End anon function
// });