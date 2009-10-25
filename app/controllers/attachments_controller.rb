class AttachmentsController < ApplicationController
  before_filter :find_parents
  before_filter :login_required
  
  def new
    @attachment = Attachment.new
  end
  
  def create
    @attachment = Attachment.new
    if current_user.can?(:use_attachments, @forum)
      if params[:attachment] && !params[:attachment][:file].blank?
        @post.attachments.create(params[:attachment])
        flash[:success] = t(:Upload_successful)
      else
        if params[:commit] != t(:Post)
          flash[:error] = t(:Please_select_a_file_to_upload)
          render :action => "new"
        end
      end
    else
      flash[:error] = t(:You_cannot_post_attachments_in_this_forum)
      redirect_to forum_path(@forum)
    end
    if params[:commit] == t(:Attach_this_and_more)
      redirect_to new_topic_post_attachment_path(@topic, @post)
    elsif [t(:Attach_this_and_post), t(:Post)].include?(params[:commit]) && !performed?
      @topic.finished!
      @post.finished!
      flash[:notice] = t(:created, :thing => t(:Post))
      go_directly_to_post
    end
  end
  
  private
    def find_parents
      @post = Post.find(params[:post_id], :include => [{ :topic => :forum }, :attachments])
      @topic = @post.topic
      @forum = @topic.forum
      
      if !@post.belongs_to?(current_user) && !current_user.can?(:edit_posts, @forum)
        flash[:notice] = t(:That_post_does_not_belong_to_you)
        redirect_to forum_path(@forum)
      end
      
      # Cheat a little and use this to instantize @attachments.
      @attachments ||= []
    end
end
