class AccountsController < ApplicationController
  before_filter :store_location, :only => [:profile, :index]
  before_filter :login_required, :only => [:profile, :index]
  
  def index
    @users = User.paginate :page => params[:page], :per_page => 30, :order => "login ASC"
  end
  
  def login
    if logged_in?
      flash[:notice] = "You are already logged in."
      redirect_back_or_default(forums_path) 
    end
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      current_user.update_attribute("previous_login",current_user.login_time)
      current_user.update_attribute("login_time",Time.now)
      current_user.update_attribute("ip",request.remote_addr)
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      flash[:notice] = "Logged in successfully"
      redirect_back_or_default(forums_path)
    else
      flash[:notice] = "The username or password you provided is incorrect. Please try again."
    end
  end
  
  def signup
    if logged_in?
      flash[:notice] = "You are already logged in. You cannot signup again."
      redirect_back_or_default(forums_path) and return false
    end
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(forums_path)
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] = "There was a problem during signup."
  end
  
  def logout
    redirect_to('login') and return false unless logged_in?
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to(forums_path)
  end
  
  def profile
    @user = current_user
    @themes = Theme.find(:all, :order => "name ASC")
    if request.post?
      params[:user][:crypted_password] = current_user.encrypt(params[:user][:password])  if params[:user][:password] == params[:user][:password_confirmation] && !params[:user][:password].blank? 
      flash[:notice] = "Password has been changed. Please remember to use this password from now on. Your profile has been updated." unless params[:user][:crypted_password].nil?
      current_user.update_attributes(params[:user])
      flash[:notice] ||= "Your profile has been updated."
    end
  end

  def user
    @user = User.find_by_login(params[:id])
    if !@user.nil?
      @posts_percentage = Post.count > 0 ? @user.posts.size.to_f / Post.count.to_f * 100 : 0
    else
      flash[:notice] = "The user you are looking for does not exist!"
      redirect_back_or_default(forums_path)
    end
  end
  
  def ip_is_banned
    unless ip_banned?
      flash[:notice] = "Your IP is not banned!"
      redirect_to forums_path
    end
  end
end
