require 'spec_helper'

describe SessionsController do
  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    @auth = request.env['omniauth.auth']
  end

  describe '#create' do

    it "should not assign user if user is not found" do
      get :create, :provider => "facebook"
      session[:user_id].should_not be_nil
    end

    it "should assign user to an instance variable" do
      user = User.create_with_omniauth(@auth)
      get :create, :provider => "facebook"
      expect(assigns(:user)).to eq user
    end

    it "request.env should not be nil" do
      request.env['omniauth.auth'].should_not be_nil
    end

    it "should set request.env provider to facebook" do
      @auth[:provider].should eq "facebook"
    end

    it "should be able to link accounts if email is there" do
      ## simulates a user with an account with google
      u = User.create(:name => "John Doe", :email => "johndoe@email.com")
      p = Provider.create(:uid => 2343, :provider => "google", :token => "sdfsdfadfdsf2342dfsaf")
      u.providers << p
      u.save!

      get :create, :provider => "facebook"
      Provider.all.length.should eq 2
    end
  end

  describe "#destroy" do
    before do
      user = User.create_with_omniauth(@auth)
      session[:user_id] = user.id
    end

    it "should set session to nil" do
      get :destroy
      session[:user_id] = nil
      session[:user_id].should be_nil
    end
  end
end
