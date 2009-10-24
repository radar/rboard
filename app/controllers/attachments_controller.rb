class AttachmentsController < ApplicationController
  before_filter :find_forum
  
  def new
    @attachment = Attachment.new
  end
  
  def create
    @attachment = Attachment.new
    currently = params[:currently]
    if !logged_in?
      flash.now[:error] = t(:you_must_be_logged_in)
    else    
      # We find the forum because we want to see if the current user can post in it.
      forum = Forum.find(params[:forum_id])
      
      if current_user.can?(:use_attachments, @forum)
        if params[:attachment] && params[:attachment][:file]
          # Get the time of the post, this is set in PostsController#new/#create/#edit
          # Anything goes. For the time being.
          session[currently] ||= []
          session[currently] << Attachment.create(params[:attachment]).id
          flash.now[:success] = t(:Upload_successful)
        else
          flash.now[:error] = t(:Please_select_a_file_to_upload)
        end
      else
        flash.now[:error] = t(:You_cannot_post_attachments_in_this_forum)
      end
    end
    
    # session[currently] may not be set because this action failed.
    # Previous uploads for this post may have succeeded, so we need to gather regardless.
    @attachments = Attachment.find(session[currently]) if session[currently]
    render :action => "new"
  end
  
  private
    def find_forum
      @forum = Forum.find(params[:forum_id])
      
      # Cheat a little and use this to instantize @attachments.
      @attachments ||= []
    end
end
