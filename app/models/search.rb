module Enumerable
  def threaded_map
    threads = map do |object|
      Thread.new { yield object }
    end
    threads.map(&:value)
  end
end

class Search

  def self.google_places_info(coordinates, name)
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
      google_info['photo'] = "nophoto.png"
    else
      photo_ref = one_spot['photos'][0]['photo_reference']
      google_info['photo'] = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_ref}&sensor=true&key=#{ENV['GOOGLE_PLACES']}"
    end

    if one_spot.nil?
      google_info['rating'] = "Not available"
    else
      google_info['rating'] = one_spot['rating']
    end

    if one_spot.nil? || one_spot['vicinity'].nil?
      google_info['address'] = "Not available"
    else
      google_info['address'] = one_spot['vicinity']
    end

    google_info
  end

  def self.good_food_places_info(latitude, longitude)
    client = Yelp::Client.new
    request = Yelp::V2::Search::Request::GeoPoint.new(
      :term => "food",
      :latitude => latitude,
      :longitude => longitude,
      :sort => 1,
      # :radius_filter => 3000, # in meters!!!
      :consumer_key => ENV['YELP_KEY'],
      :consumer_secret => ENV['YELP_SECRET'],
      :token => ENV['YELP_TOKEN'],
      :token_secret => ENV['YELP_TOKEN_SECRET']
    )
    response = client.search(request)['businesses']

    good_food = response.threaded_map do |y|

      if (y['rating'] >= 4) && (y['review_count'] >= 50)
        name = y['name']
        yelp_avg_rating = y['rating']
        phone = y['phone']
        review_count = y['review_count']
        url = y['url']
        latitude = y['location']['coordinate']['latitude']
        longitude = y['location']['coordinate']['longitude']
        coordinates = "#{latitude},#{longitude}"
        categories = (y['categories'].map {|c| c[0] }).map(&:capitalize).join(', ') unless y['categories'].nil?
        distance = y['distance']
        google_info = google_places_info(coordinates, name)
        address = "#{google_info['address']}, #{y['location']['state_code']} #{y['location']['postal_code']}"

        place_info = {name: name,
                      distance: distance,
                      open: google_info['is_open'],
                      categories: categories || [],
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
    if good_food == []
      "Sorry! There's no good food there."
    else
      good_food
    end
  end
end
