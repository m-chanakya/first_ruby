class UsersController < ApplicationController
  before_filter :authenticate_user, :only => [:edit, :update]
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
  
  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update_attributes(user_params)
      flash[:success] = "Account updated"
      redirect_to home_url
    else
      render 'edit'
    end
  end
  
  def delete
    user = User.find(session[:user_id])
    session[:user_id] = nil
    user.delete
    redirect_to root_url, :notice => "User Deleted!"
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :username, :email, :password)
  end
end