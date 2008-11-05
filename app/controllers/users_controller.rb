class UsersController < ApplicationController
  before_filter :store_location, :only => [:index]
  before_filter :login_required, :only => [:edit, :update, :index]
  
  def index
    @users = User.paginate :page => params[:page], :per_page => 30, :order => "login ASC"
  end

  def show
    @user = User.find_by_login(params[:id])
    if !@user.nil?
      @posts_percentage = Post.count > 0 ? @user.posts.size.to_f / Post.count.to_f * 100 : 0
    else
      flash[:notice] = t(:user_does_not_exist)
      redirect_back_or_default(forums_path)
    end
  end
  
  def edit
    @themes = Theme.find(:all, :order => "name ASC")
  end
  
  def update
    if !params[:user][:password].nil? &&
       params[:user][:password] == params[:user][:password_confirmation]
      params[:user][:crypted_password] = current_user.encrypt(params[:user][:password])
      flash[:notice] = t(:password_has_been_changed)
    end
    current_user.update_attributes(params[:user])
    flash[:notice] ||= t(:profile_has_been_updated)
    redirect_to edit_user_path(current_user)
  end
  
  def login
    if request.get? && logged_in?
      flash[:notice] = t(:already_logged_in)
      redirect_back_or_default(forums_path) and return false
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
      flash[:notice] = t(:logged_in_successfully)
      redirect_back_or_default(forums_path) and return false
    else
      flash[:notice] = t(:username_or_password_incorrect)
    end
  end
  
  def signup
    if logged_in?
      flash[:notice] = t(:already_logged_in)
      redirect_back_or_default(forums_path)
    end
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(forums_path)
    flash[:notice] = t(:thanks_for_signing_up)
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] = t(:problem_during_signup)
  end
  
  def logout
    redirect_to('login') and return false unless logged_in?
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = t(:you_have_been_logged_out)
    redirect_to(forums_path)
  end

  def ip_is_banned
    unless ip_banned?
      flash[:notice] = t(:ip_is_banned)
      redirect_to forums_path
    end
  end
end
