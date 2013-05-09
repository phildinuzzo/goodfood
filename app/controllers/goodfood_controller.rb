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
      @lng = lng1['location']['lng']
      @city = @results[0].address_components[3]["long_name"]
      #### Pass in the data you want here ####
      #  s = Search.good_food_places_info(street, city, state)
      #  @name = s[0][:name]
      #  play around with this hash object that I called above phil
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



