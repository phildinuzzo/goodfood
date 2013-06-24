// var lat_and_lng = "37.7841804,-122.39427649999999"

$(document).ready(function(){
  // $(document).bind('pageinit')

  $('#unhide_address').tap( function () {
    var hidden = $('.hide');
    hidden.removeClass('hide');
    $('#unhide_address').addClass('hide');
  });

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

//////////////////////////// AUTOCOMPLETE ///////////////////////////

  function initialize() {

      var input = /** @type {HTMLInputElement} */(document.getElementById('searchTextField'));
      var autocomplete = new google.maps.places.Autocomplete(input);

      google.maps.event.addListener(autocomplete, 'place_changed', function() {
        infowindow.close();
        marker.setVisible(false);
        input.className = '';
        var place = autocomplete.getPlace();
        if (!place.geometry) {
          // Inform the user that the place was not found and return.
          input.className = 'notfound';
          return;
        }

           var address = '';
           if (place.address_components) {
             address = [
               (place.address_components[0] && place.address_components[0].short_name || ''),
               (place.address_components[1] && place.address_components[1].short_name || ''),
               (place.address_components[2] && place.address_components[2].short_name || '')
             ].join(' ');
           }

           infowindow.setContent('<div><strong>' + place.name + '</strong><br>' + address);
           infowindow.open(map, marker);
         });

  }

  google.maps.event.addDomListener(window, 'load', initialize);

}); // End of document ready