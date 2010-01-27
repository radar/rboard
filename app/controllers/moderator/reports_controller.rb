class Moderator::ReportsController < Moderator::ApplicationController
  before_filter :find_reportable

  def index
    @reports = Report.find(:all, :order => "created_at DESC")
  end

  private
    def find_reportable
      @reportable = Post.find(params[:post_id]) if params[:post_id]
      @reportable = Topic.find(params[:topic_id]) if params[:topic_id]
    end
end