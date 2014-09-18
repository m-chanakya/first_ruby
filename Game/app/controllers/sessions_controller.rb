class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home]
  before_filter :save_login_state, :only => [:create, :new]
  
  def new
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged In!!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end
  
  def home
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged Out!!"
  end
  
end
