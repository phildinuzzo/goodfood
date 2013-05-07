module GeocoderHelper

  def get_geolocation
    @ip = request.location
    @location = Geocoder.search("64.71.24.19")    # replace with ip
    @lat_auto = @location[0].latitude
    @lng_auto = @location[0].longitude
    @coord = @lat_auto.to_s + "," + @lng_auto.to_s
    geo_data = Geocoder.search(@coord)
    @street_num = geo_data[0].address_components[0]["long_name"]
    @street_name = geo_data[0].address_components[1]["short_name"]
    @city_name = geo_data[0].address_components[3]["long_name"]

  end

end

# TEST IP ADDRESS! ~~~~
# '64.71.24.19'    "204.57.220.1"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Search for geographic information about a street address,
# IP address, or set of coordinates (Geocoder.search returns an
#   array of Geocoder::Result objects):

# Geocoder.search("1 Twins Way, Minneapolis")
# Geocoder.search("44.981667,-93.27833")
# Geocoder.search("204.57.220.1")


# Get current user's city and country (using IP address).
# A location method is added to the standard Rack::Request which
# returns a Geocoder::Result object:

# # Rails controller or Sinatra app
# city = request.location.city
# country = request.location.country_code

