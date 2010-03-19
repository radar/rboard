class UsersController < ApplicationController
  before_filter :store_location, :only => [:index]
  before_filter :login_required, :only => [:edit, :update, :index]
  include Rboard::Login

  def index
    @users = User.paginate :page => params[:page], :per_page => 30, :order => "login ASC"
  end

  def show
    @user = User.find_by_permalink!(params[:id])
    @posts_percentage = Post.count > 0 ? @user.posts.count.to_f / Post.count.to_f * 100 : 0
    rescue ActiveRecord::RecordNotFound 
      flash[:notice] = t(:not_found, :thing => "user")
      redirect_back_or_default(users_path)
  end

  def edit
    @themes = Theme.all
  end

  def update
    if !params[:user][:password].blank? &&
       params[:user][:password] == params[:user][:password_confirmation]
      params[:user][:crypted_password] = current_user.encrypt(params[:user][:password])
      flash[:notice] = t(:password_has_been_changed)
    end
  end


  def ip_is_banned
    unless ip_banned?
      flash[:notice] = t(:ip_is_banned)
    end
    redirect_to forums_path
  end
end
