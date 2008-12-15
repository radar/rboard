class Admin::TopicsController < Admin::ApplicationController
  before_filter :find_ip
  
  # Find topics for a particular IP.
  def index
    @topics = @ip.topics
  end
  
  private
    def find_ip
      @ip = Ip.find(params[:ip_id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = t(:ip_not_found)
      redirect_to admin_root_path
    end
end
