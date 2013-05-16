require 'spec_helper'

describe GoodfoodController do
  describe "#results", "geocode" do
    it "should be return array of results" do
      get :results, {:lat => "47.368594", :lng => "-122.178955"}
      assigns(:state).should eq "WA"
    end

    it "should be return array of results even if query is not nil" do
      get :results, {:query => "seattle", :lat => "47.368594", :lng => "-122.178955"}
    end
  end

  describe "#get_address" do
    it "should save geo data into a hash" do
      get :get_address, {:lat => "47.368594", :lng => "-122.178955"}
    end
  end

  describe "#save fav" do
    it "should save fav" do
    end
  end

  describe "#delete_favorite" do
    it "should delete favorite from database" do
      user = User.create(:name => "John Doe", :email => "johndoe@email.com")
      f = Favorite.new(:data => {shit: "sdfhs"})
      user.favorites << f
      user.save!
      get :delete_favorite, {:id => f.id}
      Favorite.all.should eq []
    end
  end
end
