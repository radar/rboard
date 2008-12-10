class Admin::PostsController < Admin::ApplicationController
  before_filter :find_ip
  def index
    @posts = @ip.posts
  end
  
  private
    def find_ip
      @ip = Ip.find(params[:ip_id])
    end
end
