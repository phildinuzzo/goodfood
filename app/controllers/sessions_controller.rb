class SessionsController < ApplicationController
  def create
     auth = request.env["omniauth.auth"]
     @provider = Provider.find_with_omniauth(auth)
     @user = User.find_by_email(auth['info']['email'])

    # if @provider.nil?
      # @provider = Provider.create_with_omniauth(auth)
    # end

    if signed_in?
      if @provider.user == current_user
        puts 'Here'
        redirect_to root_url, notice: "Already linked that account!"
      else
        @user.providers << Provider.find_by_omniauth(auth)
        @user.save!
        puts 'should be linking'
        redirect_to root_url, notice: "Successfully linked that account!"
      end
    else
      if @provider.nil?
        p = Provider.create_with_omniauth(auth)
        @user.providers << p
        @user.save!
      elsif @user.present?
        session[:user_id] = @user.id
        puts 'present'
        redirect_to root_url, notice: "Signed in!"
      else
        created_user = User.create_with_omniauth(auth)
        session[:user_id] = created_user.id
        puts 'not present'
        redirect_to root_url, notice: "Thanks for signing up"
      end
    end
  end

  def home
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
