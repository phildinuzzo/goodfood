class GoodfoodController < ApplicationController

  def results
    #This is the code to get the Geocoder object
    # from the search box on index page
    address = params[:query]
    @results = Geocoder.search(address)
  end

end



