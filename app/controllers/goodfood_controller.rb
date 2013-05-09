class GoodfoodController < ApplicationController

  def results
    #This is the code to get the Geocoder object
    # from the search box on index page and extracts lat and lng

    begin
        address = params[:query]
        @results = Geocoder.search(address)   # !!!!!replace with address variable!!!!!
        lat1 = @results[0].geometry
        @lat = lat1['location']['lat']
        lng1 = @results[0].geometry
        @lng = lat1['location']['lng']
        @city = @results[0].address_components[3]["long_name"]
    rescue
        redirect_to :back
    end
    # map.setCenter(results[0].geometry.location); FOR USE WITH MAP!!
  end

  def login
  end

  def search

  end

end



