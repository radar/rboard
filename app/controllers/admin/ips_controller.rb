class Admin::IpsController < Admin::ApplicationController
  before_filter :find_user
  def index
    @ips = @user.ips
  end
  
  private
  
    def find_user
      @user = User.find_by_permalink(params[:user_id])
    rescue ActiveRecord::NotFound
      flash[:notice] = t(:user_does_not_exist)
    end
end
