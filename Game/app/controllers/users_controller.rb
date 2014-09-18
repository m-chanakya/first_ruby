class UsersController < ApplicationController
  before_filter :authenticate_user, :only => [:update]
  before_filter :save_login_state, :only => [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
  
  def update
    user = User.authenticate(params[:email], params[:old_password])
    if user
      user.name = params[:user]
      user.username = params[:username]
      user.password = params[:new_password]
      flash[:success] = "Profile updated"
      render "sessions/home"
    else
      render "update"
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :username, :email, :password)
  end
end