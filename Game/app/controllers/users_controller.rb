class UsersController < ApplicationController
  before_filter :authenticate_user, :only => [:edit, :update, :delete]
  before_filter :save_login_state, :only => [:new, :create]
  before_filter :authorized?, :only => [:admin_page, :admin_user_update, :admin_user_delete, :admin_user_create, :upload, :admin_image_update, :admin_image_delete]
  
  helper_method :upload
  
  def admin_page
    @user_all = User.all
    @image_all = Images.all
  end
  
  def addTags(tags)
    tgs = tags.split(',')
    tgs.each do |t|
      tg = Tags.find_by tag: t
      if tg
        tg.freq = tg.freq + 1
      else
        tg = Tags.new
        tg.tag = t
        tg.freq = 1
      end
      tg.save
    end
  end
  
  def rmTags(tags)
    tgs = tags.split(',')
    tgs.each do |t|
      tg = Tags.find_by tag: t
      tg.freq = tg.freq - 1
      tg.save
    end
  end
  
  def upload
    uploaded_io = params[:picture]
    File.open(Rails.root.join('app', 'assets', 'images', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    img = Images.new
    img.name = uploaded_io.original_filename
    img.tags = params[:tags]
    if img.save
      flash[:success] = "Image Added"
      addTags(params["tags"])
    else
      flash[:error] = "Invalid Image Entry"
    end
    redirect_to "/users/admin_page#images"
  end
  
  def admin_image_update
    img = Images.find_by name: params["original-name"]
    img.name = params["name"]
    img.tags = params["tags"]
    if img.save
      old_name = Rails.root.join('app', 'assets', 'images', params["original-name"])
      new_name = Rails.root.join('app', 'assets', 'images', params["name"])
      File.rename(old_name, new_name)
      flash[:success] = "Image Added"
      rmTags(params["original-tags"])
      addTags(params["tags"])
    else
      flash[:error] = "Invalid Image Entry"
    end
    redirect_to "/users/admin_page#images"
  end
  
  def admin_image_delete
    img = Images.find_by name: params["original-name"]
    rmTags(params["original-tags"])
    File.delete(Rails.root.join('app', 'assets', 'images', params["original-name"]))
    img.delete
    redirect_to "/users/admin_page#images"
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
      flash[:error] = "Invalid User Entry"
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
      redirect_to login_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
  
  def edit
    if session[:fb]
      redirect_to home_url, :notice => "Not for FB users"
    else
      @user = User.find(session[:user_id])
    end
  end

  def update
    if session[:fb]
      redirect_to home_url, :notice => "Not for FB users"
    else
      @user = User.find(session[:user_id])
      if @user.update_attributes(user_params)
        flash[:success] = "Account updated"
        redirect_to home_url
      else
        render 'edit'
      end
    end
  end
  
  def delete
    if session[:fb]
      redirect_to home_url, :notice => "Not for FB users"
    else
      user = User.find(session[:user_id])
      session[:user_id] = nil
      user.delete
      redirect_to home_url, :notice => "User Deleted!"
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :username, :email, :password)
  end
end