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
      location = Geocoder.search(whole_address)
      lat1 = location[0].latitude
      lng1 = location[0].longitude
      @s = Search.good_food_places_info(lat1, lng1)
    else
      @s = Search.good_food_places_info(@lat, @lng)
    end

    # JY: Sort results to insure that open items appear first
    @s.sort! { |a,b|
      a_openness = a[:open] ? '0 ' : '1 '
      b_openness = b[:open] ? '0 ' : '1 '
      a_comp = a_openness + a[:name]
      b_comp = b_openness + b[:name]
      puts "#{a_comp} <=> #{b_comp}"
      a_comp <=> b_comp
    }

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

  def save_favorite
    # decode
    @i = ActiveSupport::JSON.decode Base64.decode64(params[:i])
    @i.symbolize_keys!
    Favorite.create(:data => @i.to_json, :user_id => current_user.id)
    redirect_to :favorites
    #render :result
  end

  def favorites
    # set the id on each
    @s = current_user.favorites.collect do |f|
      # decode the hash
      i = ActiveSupport::JSON.decode(f.data).symbolize_keys
      i[:id] = f.id
      i
    end
    render 'results'
  end

  def delete_favorite
    f = Favorite.find(params[:id])
    f.destroy
    redirect_to :favorites
  end

end



