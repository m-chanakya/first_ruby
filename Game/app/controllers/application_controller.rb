class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :admin?, :fb?
  
  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def fb?
    return session[:fb]
  end
  
  def admin?
    if session[:user_id]
      user = User.find(session[:user_id])
      if user.email == "admin@gmail.com" and user.username = "Admin"
        return true
      else
        return false
      end
    end
  end
  
  protected 
  def authenticate_user
    if session[:user_id] 
      @current_user ||= User.find(session[:user_id])
      return true	
    elsif session[:fb]
      return true
    else
      flash[:error] = "Must be logged in!!"
      redirect_to login_url
      return false
    end
  end

  def save_login_state
    if session[:user_id]
      redirect_to(:controller => 'sessions', :action => 'home')
      return false
    else
      return true
    end
  end
  
  def authorized?
    if admin?
      return true
    else
      flash[:error] = "You are not authorized to view that page."
      redirect_to home_url
      return false
    end
  end
end