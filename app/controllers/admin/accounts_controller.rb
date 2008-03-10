class Admin::AccountsController < Admin::ApplicationController
  before_filter :store_location, :only => [:index]
  
  def ban_ip
    if request.post?
      params[:banned_ip][:ban_time] = Chronic.parse(params[:banned_ip][:ban_time])
      params[:banned_ip][:ip].gsub!(".","\.").gsub("*","[0-9]{1,3}")
      params[:banned_ip][:banned_by] = session[:user]
      @banned_ip = BannedIp.new(params[:banned_ip])
      if @banned_ip.save
        flash[:notice] = "The IP range has been banned."
      else
        flash[:notice] = "The IP range could not be banned."
      end
    
    else
      @banned_ip = BannedIp.new(params[:banned_ip])
    end

    @banned = BannedIp.find(:all, :conditions => ["ban_time > ?",Time.now])
  end
  
  def ban
    @user = User.find(:first)
    if request.post?
      params[:user][:banned_by] = current_user
      params[:user][:ban_time] = Chronic.parse(params[:user][:ban_time])
      @user.update_attributes(params[:user])
      @user.increment!('ban_times')
      flash[:notice] = "User has been banned!"
      redirect_back_or_default(:action => "list")
    end
  end
  
  def remove_banned_ip
    @banned_ip = BannedIp.find(params[:id]).destroy
    flash[:notice] = "The IP range has been unbanned."
    redirect_to :action => :ban_ip
  end
  
  def index
    @users = User.find(:all)
  end
  
  def edit
    @user = User.find(params[:id])
    @ranks = Rank.find_all_by_custom(true)
    @userlevels = UserLevel.find(:all)
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    flash[:notice] = "This user has been updated."
    redirect_back_or_default(admin_accounts_path)
  end
  
  def user
    @user = User.find_by_login(params[:id])
    @posts_percentage = Post.count > 0 ? @user.posts.size.to_f / Post.count.to_f * 100 : 0
  end
end