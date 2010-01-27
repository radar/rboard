class Admin::IpsController < Admin::ApplicationController
  before_filter :find_user

  # List all IPs that a user has used.
  def index
    @ips = @user.ips.find(:all, :include => [:topics, :posts]).paginate(:page => params[:page], :per_page => per_page)
  end

  # Find intricate details about a specific IP.  
  def show
    @ip = Ip.find(params[:id], :include => [:topics, :posts])
  end

  private

    def find_user
      @user = User.find_by_permalink!(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = t(:not_found, :thing => "user")
        redirect_to admin_users_path
    end
end
