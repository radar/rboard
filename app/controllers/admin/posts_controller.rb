class Admin::PostsController < Admin::ApplicationController
  before_filter :find_ip

  # Find all posts for a particular IP.
  def index
    @posts = @ip.posts
  end

  private
    def find_ip
      @ip = Ip.find(params[:ip_id], :include => :posts)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = t(:not_found, :thing => "ip")
      redirect_to admin_root_path
    end
end
