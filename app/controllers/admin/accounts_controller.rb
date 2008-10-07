class Admin::AccountsController < Admin::ApplicationController
  before_filter :store_location, :only => [:index]
  
  # Used for banning ips
  # Firstly gathers the time to ban to and parses it using Chronic
  # Escapes all . in the ip and replaces all * with [0-9]{1,3}
  # The save really shouldn't fail, but just in case it does.
  # 
  #
  # TODO: Validate that the IP is an actual possible IP.
  # TODO: Rescue Chronic exceptions when given incorrect dates.
  # TODO: Dates should not be able to be set in the past.
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
      @banned_ip = BannedIp.new(:ip => params[:id])
    end
    @banned = BannedIp.find(:all, :conditions => ["ban_time > ?",Time.now])
  end
  
  # Used for banning users.
  # Will tell the user they are banning themselves before it happens.
  # 
  # TODO: Rescue Chronic exceptions when given incorrect dates.
  def ban
    @user = User.find(params[:id])
    flash[:notice] = "You have selected to ban yourself. If you have no problem with this, go ahead." if @user == current_user
    if request.put?
      params[:user][:banned_by] = current_user
      params[:user][:ban_time] = Chronic.parse(params[:user][:ban_time])
      @user.update_attributes(params[:user])
      @user.increment!('ban_times')
      flash[:notice] = "User has been banned!"
      redirect_back_or_default(admin_accounts_path)
    end
  end
  
  # Maybe should be moved to a banned ip controller...
  # Removes a banned IP immediately.
  def remove_banned_ip
    @banned_ip = BannedIp.find(params[:id]).destroy
    flash[:notice] = "The IP range has been unbanned."
    redirect_back_or_default ban_ip_admin_accounts_path
  end
  
  
  # Show all the users, in no particular order.
  def index
    @users = User.find(:all)
  end
  
  # Edit the details for a specific user. 
  def edit
    @user = User.find(params[:id])
    @ranks = Rank.find_all_by_custom(true)
    @userlevels = UserLevel.find(:all)
  end
  
  # Updates the details for a specific user.  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "This user has been updated."
      redirect_to admin_accounts_path
    else
      flash[:notice] = "This user could not be updated."
      render :action => "edit"
    end
  end
  
  # Is this even used any more?  
  def user
    @user = User.find_by_login(params[:id])
    @posts_percentage = Post.count > 0 ? @user.posts.size.to_f / Post.count.to_f * 100 : 0
  end
end