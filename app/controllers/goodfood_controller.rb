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
    # address = params[:query]
    # @results = Geocoder.search('640 post st, sf')   # !!!!!replace with address variable!!!!!
    # lat1 = @results[0].geometry
    # @lat = lat1['location']['lat']
    # lng1 = @results[0].geometry
    # @lng = lng1['location']['lng']
    # @city = @results[0].address_components[3]["long_name"]


    @lat = params[:lat]
    @lng = params[:lng]
    coords = @lat + "," + @lng
    @geo_data = Geocoder.search(coords)
    @st_num = @geo_data[0].address_components[0]["long_name"]
    @st_name = @geo_data[0].address_components[1]["short_name"]
    @city = @geo_data[0].address_components[3]["long_name"]
    @state = @geo_data[0].address_components[4]["short_name"]
    @street = @st_num + "" + @st_name

    @s = Search.good_food_places_info(@street, @city, @state)

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



