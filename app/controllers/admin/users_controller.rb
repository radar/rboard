class Admin::UsersController < Admin::ApplicationController
  before_filter :store_location, :only => [:index]
  before_filter :find_ip
  before_filter :find_user, :only => [:show, :edit, :update, :destroy]
  before_filter :find_group

  # Show all the users, by login in ascending order. 
  def index
    @users = if @object
      @object.users
    else
      User
    end.paginate(:order => "login ASC", :page => params[:page], :per_page => per_page)
  end

  # See details for a particular user.
  def show
  end

  # Edit the details for a specific user. 
  def edit
    @ranks = Rank.find_all_by_custom(true)
    @ranks = Rank.custom
    @userlevels = UserLevel.all
  end

  # Updates the details for a specific user.  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t(:updated, :thing => "user")
      redirect_to admin_users_path
    else
      flash[:notice] = t(:not_updated, :thing => "user")
      render :action => "edit"
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = t(:deleted, :thing => "user")
    redirect_to admin_users_path
  end

  def search
    # TODO: Switch to using thinking sphinx. Work out how to get this tested.
    render :text => User.search(params[:q]).flatten.map(&:login).join("\n")
  end


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
        flash[:notice] = t(:ip_banned)
      else
        flash[:notice] = t(:ip_not_banned)
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
    @user = User.find_by_login(params[:id])
    flash[:notice] = t(:you_are_banning_yourself) if @user == current_user
    if request.put?
      params[:user][:banned_by] = current_user
      params[:user][:ban_time] = Chronic.parse(params[:user][:ban_time])
      @user.update_attributes(params[:user])
      @user.increment!('ban_times')
      flash[:notice] = t(:user_has_been_banned)
      redirect_back_or_default(admin_users_path)
    end
  end

  # Maybe should be moved to a banned ip controller...
  # Removes a banned IP immediately.
  def remove_banned_ip
    @banned_ip = BannedIp.find(params[:id]).destroy
    flash[:notice] = t(:ip_range_unbanned)
    redirect_back_or_default ban_ip_admin_users_path
  end


  private

  def find_user
    @user = User.find_by_permalink(params[:id])
  end

  def find_ip
    @object = Ip.find(params[:ip_id]) unless params[:ip_id].nil?
  end

  def find_group
    @object = Group.find(params[:group_id]) unless params[:group_id].nil?
  end


end