class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :play, :checkAns]
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
    
  def play
    @timer = 10
    if session["checker"] == nil
      session["checker"] = 1
    end
    if session[:score ] == nil
      session[:score] = 0
    end
    if session["checker"] == 1
      tmp = Photos.getRandImg
      sz = tmp.size
      session["img1"] = tmp[rand(sz)]
      session["img2"] = tmp[rand(sz)]
      session["img3"] = tmp[rand(sz)]
      session["img4"] = tmp[rand(sz)]
      while session["img1"] == session["img2"]
        session["img2"] = tmp[rand(sz)]
      end
      while session["img3"] == session["img2"] or session["img3"] == session["img1"]
        session["img3"] = tmp[rand(sz)]
      end
      while session["img4"] == session["img3"] or session["img4"] == session["img2"] or session["img4"] == session["img1"]
        session["img4"] = tmp[rand(sz)]
      end
    else
      puts "chanu randi"
    end
  end
  
  def checkAns
    if Photos.chk(params["ans"])
      session[:score] = session[:score] + 3;
      session["checker"] = 1
    else
      session[:score] = session[:score] - 1;
      session["checker"] = 0
    end
    redirect_to :action => "play"
  end
  
end
