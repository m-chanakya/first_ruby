class UsersController < ApplicationController
  before_filter :authenticate_user, :only => [:edit, :update, :admin_page, :admin_user_update, :admin_user_delete]
  before_filter :save_login_state, :only => [:new, :create]
  before_filter :authorized?, :only => [:admin_page, :admin_user_update, :admin_user_delete]
  
  def admin_page
    @user_all = User.all
  end
  
  def admin_user_update
    user = User.find_by email: params[:email]
    user.name = params[:name]
    user.email = params[:email]
    user.username = params[:username]
    if user.save
      flash[:success] = "Account updated"
    end
    redirect_to :action => "admin_page"
  end
  
  def admin_user_delete
    user = User.find_by username: params[:username]
    user.delete
    flash[:success] = "User deleted"
  end
  
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