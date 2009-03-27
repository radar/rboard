class UsersController < ApplicationController
  before_filter :store_location, :only => [:index]
  before_filter :login_required, :only => [:edit, :update, :index]
  include Rboard::Login
  
  def index
    @users = User.paginate :page => params[:page], :per_page => 30, :order => "login ASC"
  end

  def show
    @user = User.find_by_permalink(params[:id])
    if !@user.nil?
      @posts_percentage = Post.count > 0 ? @user.posts.size.to_f / Post.count.to_f * 100 : 0
    else
      flash[:notice] = t(:user_not_found)
      redirect_back_or_default(forums_path)
    end
  end
  
  def edit
    @themes = Theme.find(:all, :order => "name ASC")
  end
  
  def update
    if !params[:user][:password].blank? &&
       params[:user][:password] == params[:user][:password_confirmation]
      params[:user][:crypted_password] = current_user.encrypt(params[:user][:password])
      flash[:notice] = t(:password_has_been_changed)
    end
    current_user.update_attributes(params[:user])
    flash[:notice] ||= t(:profile_has_been_updated)
    redirect_to edit_user_path(current_user)
  end
  

  def ip_is_banned
    unless ip_banned?
      flash[:notice] = t(:ip_is_banned)
      redirect_to forums_path
    end
  end
end
