class GoodfoodController < ApplicationController

  def index
    # @ip = request.env["REMOTE_ADDR"]
    # @location = Geocoder.search(@ip)    # replace with ip
    # @lat_auto = @location[0].latitude
    # @lng_auto = @location[0].longitude
    # @coord = @lat_auto.to_s + "," + @lng_auto.to_s
    # geo_data = Geocoder.search(@coord)
    # unless geo_data.empty?
    #   @street_num = geo_data[0].address_components[0]["long_name"]
    #   @street_name = geo_data[0].address_components[1]["short_name"]
    #   @city_name = geo_data[0].address_components[3]["long_name"]
    # end
  end

  def results
    #This is the code to get the Geocoder object
    # from the search box on index page and extracts lat and lng

      # address = params[:query]
      # @results = Geocoder.search(address)   # !!!!!replace with address variable!!!!!
      # lat1 = @results[0].geometry
      # @lat = lat1['location']['lat']
      # lng1 = @results[0].geometry
      # @lng = lng1['location']['lng']
      # @city = @results[0].address_components[3]["long_name"]
      #### Pass in the data you want here ####
      @s = Search.good_food_places_info('post street', 'san francisco', 'ca')
      #  @name = s[0][:name]
      #  play around with this hash object that I called above phil

    # map.setCenter(results[0].geometry.location); FOR USE WITH MAP!!
  end

  def get_address
    @lat = params[:lat]
    @lng = params[:lng]
    @test = "test"
    @coords = @lat + "," + @lng
    geo_data = Geocoder.search(@coords)
    response = {}
    response[:street_num] = geo_data[0].address_components[0]["long_name"]
    response[:street_name] = geo_data[0].address_components[1]["short_name"]
    response[:city_name] = geo_data[0].address_components[3]["long_name"]
    render :json => response

  end

  def login
  end

  def search
  end
end



