// var lat_and_lng = "37.7841804,-122.39427649999999"

$(document).ready(function(){

  function onPositionUpdate(position) {
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;

    $.ajax({
        url: 'index',
        data: {lat: lat,lng: lng},
        type: 'post',
        dataType: 'json',
      success: function(geo_data) {
        $('#street-num').html(geo_data.street_num);
        $('#street-name').html(geo_data.street_name);
        $('#city-name').html(geo_data.city_name);
        $('form').append(
        $('<input/>')
            .attr('type', 'hidden')
            .attr('name', 'lat')
            .val(geo_data.latitude)
             );
        $('form').append(
        $('<input/>')
            .attr('type', 'hidden')
            .attr('name', 'lng')
            .val(geo_data.longitude)
             );







      },
      error: function() {
      }
    }); // End of Ajax
  }// end of function

  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(onPositionUpdate);
  } else {
    console.log("no geolocation");
  }

}); // End of document ready