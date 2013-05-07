

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


# TEST IP ADDRESS! ~~~~
# '64.71.24.19'

module GeocoderHelper

  def get_geolocation
    @ip = request.location
    @location = Geocoder.search('64.71.24.19')
    @lat_auto = @location[0].latitude
    @lng_auto = @location[0].longitude


    # lat1 = @location[0].geometry
    # @lat_auto = lat1['location']['lat']
    # lng1 = @location[0].geometry
    # @lng_auto = lat1['location']['lng']
  end

end

# You can use Geocoder outside of Rails by calling the
# Geocoder.search method:


# puts @results
# puts "test"

# test = Geocoder.search("204.57.220.1")
# puts test