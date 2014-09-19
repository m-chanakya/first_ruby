class UsersController < ApplicationController
  before_filter :authenticate_user, :only => [:edit, :update, :admin_page, :admin_user_update, :admin_user_delete]
  before_filter :save_login_state, :only => [:new, :create]
  before_filter :authorized?, :only => [:admin_page, :admin_user_update, :admin_user_delete, :admin_user_create]
  
  def admin_page
    @user_all = User.all
    photo_all = Photos.all
    files = Set.new
    photo_all.each do |p|
      temp = p.files.split(",")
      temp.each do |f| 
        files.add(f)
      end
    end
    
    @final = Array.new
    files.each do |f|
      photo_all.each do |p|
        if p.files.include?(f)
          f += ',' + (p.tags)
        end
        @final.push(f.split(','))
      end      
    end
  end
  
  def admin_user_create
    user = User.new()
    user.name = params["name"]
    user.email = params["email"]
    user.username = params["username"]
    user.password = params["password"]
    if user.save
      flash[:success] = "User Added"
    else
      flash[:error] = "Invalid Entry"
    end
    redirect_to "/users/admin_page"
  end
  
  def admin_user_update
    user = User.find_by username: params["original-username"]
    user.name = params["name"]
    user.email = params["email"]
    user.username = params["username"]
    user.password = params["password"]
    if user.save
      flash[:success] = "Account updated"
    else
      flash[:error] = "Invalid Change"
    end
    redirect_to "/users/admin_page"
  end
  
  def admin_user_delete
    user = User.find_by username: params["username"]
    if user.username == "Admin"
      flash[:error] = "Cannot delete admin"
    else
      user.delete
      flash[:success] = "User deleted"
    end
    redirect_to "/users/admin_page"
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