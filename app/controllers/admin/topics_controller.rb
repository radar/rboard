class Admin::TopicsController < Admin::ApplicationController
  before_filter :find_ip
  def index
    @topics = @ip.topics
  end
  
  private
    def find_ip
      @ip = Ip.find(params[:ip_id])
    end
end
