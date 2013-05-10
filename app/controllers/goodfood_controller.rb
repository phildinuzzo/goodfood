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

    @lat = params[:lat]
    @lng = params[:lng]
    coords = @lat + "," + @lng
    @geo_data = Geocoder.search(coords)
    @st_num = @geo_data[0].address_components[0]["long_name"]
    @st_name = @geo_data[0].address_components[1]["short_name"]
    @city = @geo_data[0].address_components[3]["long_name"]
    @state = @geo_data[0].address_components[4]["short_name"]
    @street = @st_num + "" + @st_name
    if params[:query] != nil
      whole_address = params[:query]
      address_array = whole_address.split(",")
      street1 = address_array[0]
      city1 = address_array[1]
      state1 = address_array[2]
      @s = Search.good_food_places_info(street1, city1, state1)
    else
      @s = Search.good_food_places_info(@street, @city, @state)
    end
  # map.setCenter(results[0].geometry.location); FOR USE WITH MAP!!
  end

  def get_address
    lat = params[:lat]
    lng = params[:lng]
    coords = lat + "," + lng
    @geo_data = Geocoder.search(coords)
    response = {}
    response[:street_num] = @geo_data[0].address_components[0]["long_name"]
    response[:street_name] = @geo_data[0].address_components[1]["short_name"]
    response[:city_name] = @geo_data[0].address_components[3]["long_name"]
    response[:latitude] = lat
    response[:longitude] = lng
    render :json => response

  end

  def login
  end

  def search
  end
end



