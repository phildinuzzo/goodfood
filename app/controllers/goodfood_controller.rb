class GoodfoodController < ApplicationController

  def results
    #This is the code to get the Geocoder object
    # from the search box on index page and extracts lat and lng
    address = params[:query]
    @results = Geocoder.search(address)
    lat1 = @results[0].geometry
    @lat = lat1['location']['lat']
    lng1 = @results[0].geometry
    @lng = lat1['location']['lng']

    # map.setCenter(results[0].geometry.location); FOR USE WITH MAP!!
  end

end



