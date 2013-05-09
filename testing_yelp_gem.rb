require 'yelp'
require 'json'
require 'open-uri'
gem 'json', '1.7.7'
require 'json'
require 'open-uri'
require 'uri'
require 'openssl'
require 'google_places'


# require 'oauth'

# consumer_key = 'fY6wOVe4OKHPb8FE_9Idmg'
# consumer_secret = 'WXO7X8_eQvCEIYv28HPQhgkSZ2E'
# token = 'slDSKW_7qjDqMl2YiCEGNAVD7Bn35fgS'
# token_secret = 'eT9hoFWiTt52_HoYrQzi-jwT_ZY'
# api_host = 'api.yelp.com'
# consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
# access_token = OAuth::AccessToken.new(consumer, token, token_secret)
# path = "/v2/search?term=restaurants&location=new%20york"
# p access_token.get(path).body

# def check_open(coordinates, name)
#   if one_spot.nil? || one_spot['opening_hours'].nil?
#     "Hours not given"
#   else
#     one_spot['opening_hours']['open_now']
#   end
# end

# def grab_photo(coordinates, name)
#   if one_spot.nil? || one_spot['photos'].nil?
#     "no photo available"
#   else
#     photo_ref = one_spot['photos'][0]['photo_reference']
#     "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_ref}&sensor=true&key=AIzaSyDgjPw63xd4qJZ50P7a-vdvjx6FQHxX8CI"
#   end
# end

# photo_url = grab_photo(coordinates, name)
# google_rating = google_place_rating(coordinates, name)
# place_open = check_open(coordinates, name)



def google_places_info(coordinates, name)
  place = name
  name_array = place.split(" ")
  spot = name_array[0]
  url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{coordinates}&name=#{URI.escape(spot)}&rankby=distance&types=food|restaurant|bakery|bar|cafe&sensor=false&key=#{ENV['GOOGLE_PLACES']}"
  uri = URI.parse(URI.encode(url.strip))
  file = open(uri, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)
  one_spot = JSON.load(file.read)['results'][0]

  google_info = {}
  if one_spot.nil? || one_spot['opening_hours'].nil?
    google_info['is_open'] = "Not available"
  else
    google_info['is_open'] = one_spot['opening_hours']['open_now']
  end

  if one_spot.nil? || one_spot['photos'].nil?
    google_info['photo'] = "Not available"
  else
    photo_ref = one_spot['photos'][0]['photo_reference']
    google_info['photo'] = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_ref}&sensor=true&key=#{ENV['GOOGLE_PLACES']}"
  end

  if one_spot.nil?
    google_info['rating'] = "Not available"
  else
    google_info['rating'] = one_spot['rating']
  end

  google_info
end

def good_food_places_info(address, city, state)
  client = Yelp::Client.new
  request = Yelp::Review::Request::Location.new(
              :address => address,
              :city => city,
              :state => state,
              :radius => 2,
              :term => 'food',
              :yws_id => ENV['YELP_WSID'])
  response = client.search(request)['businesses']

  good_food = response.map do |y|
    if (y['avg_rating'] >= 4) && (y['review_count'] >= 100)
      name = y['name']
      yelp_avg_rating = y['avg_rating']
      address = "#{y['address1']}, #{y['city']}, #{y['state']} #{y['zip']}"
      phone = y['phone']
      review_count = y['review_count']
      url = y['url']
      latitude = y['latitude']
      longitude = y['longitude']
      coordinates = "#{latitude},#{longitude}"
      categories = (y['categories'].map {|c| c['category_filter'] }).map(&:capitalize).join(', ')

      google_info = google_places_info(coordinates, name)

      place_info = {name: name,
                    open: google_info['is_open'],
                    categories: categories,
                    yelp_rating: yelp_avg_rating,
                    google_rating: google_info['rating'],
                    address: address,
                    phone: phone,
                    review_count: review_count,
                    yelp_url: url,
                    photo_url: google_info['photo'],
                    coordinates: coordinates}

      place_info
    end
  end
  good_food.reject! { |c| c.nil? }
end
puts JSON.pretty_generate good_food


# Yelp search by phone number

# request = Yelp::Phone::Request::Number.new(
#             :phone_number => '(415) 345-8100 ',
#             :yws_id => 'tQd1EAsNyd6Pmdmt653HzA')
# response = client.search(request)
# puts JSON.pretty_generate response


# lat = 37.7939484886016
# long = -122.402307987213
# coordinates = "#{lat},#{long}"
# name = "Wayfare Tavern"
# name_array = name.split(" ")
# spot = name_array[0]

# check_open(coordinates, spot)




# Get rating, phone, address from Google places

# @client = GooglePlaces::Client.new('AIzaSyDfQUGytBit3OsfLDx8OygAllI9SJnXaIM')
# spots = @client.spots(lat,long, :types => ['restaurant','food','bakery','cafe'])
# refs = spots.map {|spot| spot.reference }
# spots = refs.map {|ref| @client.spot(ref) }
# places = spots.map do |spot|
#    puts "#{spot.name} \n #{spot.rating} \n #{spot.formatted_phone_number} \n #{spot.formatted_address}"
# end

# spots = @client.spots(37.7939484886016, -122.402307987213, :types => ['restaurant','food','bakery','cafe'])
# places = spots.map do |spot|
#    puts "#{spot.name} \n #{spot.rating}"
# end




# Getting only open places at time of query

# url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{long}&opennow&name=#{URI.escape(spot)}&radius=5000&types=food|restaurant|bakery|bar|cafe&sensor=false&key=AIzaSyDfQUGytBit3OsfLDx8OygAllI9SJnXaIM"
# uri = URI.parse(URI.encode(url.strip))
# file = open(uri, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)
# places =  JSON.load(file.read)['results']
# open_now = places.map {|place| puts "\n #{place['name']} \n #{place['rating']}\n\n #{place['reference']}" if place['rating'] >= 4}
# # puts JSON.pretty_generate open_now



# Getting photos from Google Places

# photo_ref = CnRqAAAAYB95NEbhmbM-eixEeX9IajjkT6Tb4Xf8MeoDV1AzaVeWIVtWERpJa-JOmtPGz_jjsUIrrSKrBzx69pgGuiuKgJOgO9FeBMFcn29iy3E7aukRY3HjlW5HEyDa2qBVDrvqPnDXU0op7zM_12ZJsdNwABIQWwUjdwYCd68AcTQI6PKD8BoU0mFKaHK9MyX5OoF4xYd8je0eqv4
# "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_ref}&sensor=true&key=AIzaSyDfQUGytBit3OsfLDx8OygAllI9SJnXaIM"

