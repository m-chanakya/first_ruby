class SessionsController < ApplicationController
  before_filter :authenticate_user, :only => [:home, :play, :checkAns, :mail]
  before_filter :save_login_state, :only => [:create, :new]
  
  def new
  end
  
  def fb_login
    session[:fb] = true
    session[:username] = params[:username]
    session[:email] = params[:usermail]
    redirect_to home_url
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:fb] = false
      session[:user_id] = user.id
      session[:username] = user.username
      redirect_to home_url, :notice => "Logged In!!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end
  
  def home
     @lBoard = Board.order("score DESC").limit(10)
  end
  
  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to login_url, :notice => "Logged Out!!"
   end
  
  def play
    if session["attempt"] == nil
      session["attempt"] = 3
    end
    if params["level"].present?
      session["level"] = params["level"]
    end
    @timer = 20 - ((session["level"].to_i) - 1)*5
    if session["checker"] == nil
      session["checker"] = 1
    end
    if session[:score ] == nil
      session[:score] = 0
    end
    if session["checker"] == 1
      count = 0
      while true
        tmpTag = Tags.getRandTag
        session["currTag"] = tmpTag
        tmp = Images.getRandImg(tmpTag)
        puts tmp
        sz = tmp.size
        session["img1"] = tmp[rand(sz)]
        session["img2"] = tmp[rand(sz)]
        session["img3"] = tmp[rand(sz)]
        session["img4"] = tmp[rand(sz)]
        count = count + 1
        if sz>=4
          break
        end
        if count > 1500000
          redirect_to home_url, :notice => "Not Enough Images"
        end
      end
      while session["img1"]== session["img2"]
        session["img2"] = tmp[rand(sz)]
      end
      while session["img3"] == session["img2"] or session["img3"] == session["img1"]
        session["img3"] = tmp[rand(sz)]
      end
      while session["img4"] == session["img3"] or session["img4"] == session["img2"] or session["img4"] == session["img1"]
        session["img4"] = tmp[rand(sz)]
      end
    else
      puts "not working"
    end
  end
  
  def checkAns
    if Images.chk(session, params["ans"])
      session[:score] = session[:score] + 3
      session["checker"] = 1
    else
      session[:score] = session[:score] - 1
      session["checker"] = 0
      session["attempt"] = session["attempt"] - 1
    end
    redirect_to :action => "play"
  end
  
  def endGame
    session["attempt"] = nil
    tmp = Board.new
    user = session["username"]
    tmp["uname"] = user
    tmp["score"] = session[:score].to_i
    tmp.save
    session[:score] = 0
    redirect_to home_url, :notice => "Game Over!!"
  end
  
  def mail
    user = User.find_by username: session[:username]
    tmp = Board.order("score DESC").find_by uname: user.username
    if tmp
      UserMailer.challenge(params[:email], user, tmp).deliver
      redirect_to home_url, :notice => "Challenge Sent!!"
    else
      redirect_to home_url, :notice => "High Score not found!!"
    end
  end
  
end
