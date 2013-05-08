class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    @provider = Provider.find_with_omniauth(auth)
    @user_by_email = User.find_by_email(auth['info']['email'])

    ## Catches the Nil class error for the find_with_omniauth method
    unless User.find_with_omniauth(auth) == nil
      @user = User.find_with_omniauth(auth).user
    end

    if @user != nil
      session[:user_id] = @user.id
      redirect_to root_url
    elsif @user_by_email != nil
      p = Provider.create_with_omniauth(auth)
      session[:user_id] = @user_by_email.id
      @user_by_email.providers << p
      redirect_to root_url
    else
      created_user = User.create_with_omniauth(auth)
      session[:user_id] = created_user.id
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
