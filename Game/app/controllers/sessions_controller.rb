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
  
  def checkAns
    if Photos.chk(params["ans"])
      session[:score] = session[:score] + 3;
      @checker = true
    else
      session[:score] = session[:score] - 1;
      @checker = false
    end
    redirect_to :action => "play"
  end
  
  def play
    if session[:score ] == nil
      session[:score] = 0
    end
    if @checker == true or @checker==nil
      tmp = Photos.getRandImg
      sz = tmp.size
      @img1 = tmp[rand(sz)]
      @img2 = tmp[rand(sz)]
      @img3 = tmp[rand(sz)]
      @img4 = tmp[rand(sz)]
      while @img1 == @img2
        @img2 = tmp[rand(sz)]
      end
      while @img3 == @img2 or @img3 == @img1
        @img3 = tmp[rand(sz)]
      end
      while @img4 == @img3 or @img4 == @img2 or @img4 == @img1
        @img4 = tmp[rand(sz)]
      end
      @checker = false
    end
  end
  
end
