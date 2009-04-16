class Moderator::TopicsController < Moderator::ApplicationController
  before_filter :find_topic, :except => [:moderate, :merge]
  # before_filter :can_not_move?, :only => :move
  # before_filter :can_not_merge?, :only => :merge
  # before_filter :can_not_delete?, :only => :destroy
  
  def destroy
    @topic.destroy
    flash[:notice] = t(:deleted, :thing => "topic_")
    redirect_back_or_default moderator_moderations_path
  end
  
  # This method works in two ways.
  # The first way is from the moderations index action which will pass in params[:moderation_ids] if
  # any of the submit buttons on the bottom row are clicked.
  #
  # The second comes from forums/show which will use all the currently selected moderations as the objects.
  def moderate
    @moderations = Moderation.for_user(current_user).topics.find(params[:moderation_ids]) if params[:moderation_ids]
    @moderations ||= Moderation.topics.for_user(current_user.id)
    case params[:commit]
      when "Lock"
        can_not_lock?(@moderations)
        @moderations.each { |m| m.lock! }
        flash[:notice] = t(:topics_locked)
      when "Unlock"
        can_not_lock?(@moderations)
        @moderations.each { |m| m.unlock! }
        flash[:notice] = t(:topics_unlocked)
      when "Delete"
        can_not_delete?(@moderations)
        #TODO: maybe ask for confirmation?
        @moderations.each { |m| m.destroy! }
        flash[:notice] = t(:deleted, :thing => "topics_")
      when "Sticky"
        can_not_sticky?(@moderations)
        @moderations.each { |m| m.sticky! }
        flash[:notice] = t(:topics_stickied)
      when "Unsticky"
        can_not_sticky?(@moderations)
        @moderations.each { |m| m.unsticky! }
        flash[:notice] = t(:topics_unstickied)
      when "Move"
        can_not_move?(@moderations)
        move
        return false
      when "Merge"
        params[:moderation_ids] = @moderations_for_topics.map(&:moderated_object_id)
        merge
        return false
    end
    redirect_back_or_default(moderator_moderations_path) unless performed?
  rescue ActiveRecord::RecordNotFound => e
    flash[:notice] = t(:not_found, :thing => "moderation")
    redirect_back_or_default moderator_moderations_path
  end
  
  def merge
    if params[:moderation_ids]
      @topics = Topic.find(params[:moderation_ids])
      session[:moderation_ids] = params[:moderation_ids]
    end
    @topics ||= Topic.find(session[:moderated_ids])
    if @topics.size == 1
      flash[:notice] = t(:only_one_topic_for_merge)
      redirect_back_or_default forums_path
      return false
    end
    if request.put? && params[:new_subject]
      # Check if user has access to all topics
      if @topics.any? { |topic| !current_user.can?(:see_forum, topic.forum) }
        flash[:notice] = t(:topics_not_accessible_by_you)
        redirect_back_or_default(forums_path)
        return false
      end
      @topic = Topic.find(params[:master_topic_id])
      @topic.merge!(session[:moderation_ids], params[:new_subject])
      flash[:notice] = t(:topics_merged)
      redirect_back_or_default(forums_path)
    end    
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = t(:not_found, "topic")
    redirect_back_or_default moderator_moderations_path 
  end
  
  def move
    if params[:new_forum_id]
      @moderations_for_topics.each { |m| m.move!(params[:new_forum_id], params[:leave_redirect] == '1') }
      flash[:notice] = t(:topics_moved)
      redirect_back_or_default(forum_path(params[:new_forum_id]))
    end
  end
  
  def lock
    @topic.toggle!("locked")
    @topic.moderations.for_user(current_user).delete_all
    flash[:notice] = t(:topic_locked_or_unlocked, :status => @topic.locked? ? "locked" : "unlocked")
    redirect_back_or_default moderator_moderations_path
  end
  
  def sticky
    @topic.toggle!("sticky")
    @topic.moderations.for_user(current_user).delete_all
    flash[:notice] = t(:topic_sticky_or_unsticky, :status => @topic.sticky? ? "stickied" : "unstickied")
    redirect_back_or_default moderator_moderations_path
  end
  
  private
    def find_topic
      @topic = Topic.find(params[:id])
      
      # If the user is not allowed to see the topic, then they must not be allowed to change it either.
      if !current_user.can?(:see_forum, @topic.forum)
        flash[:notice] = t(:forum_object_permission_denied, :object => "topic")
        @topic.moderations.for_user(current_user).each { |m| m.destroy }
        redirect_to moderator_moderations_path
      end
      
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = t(:not_found, :thing => "topic")
        redirect_to moderator_moderations_path
    end
    
    def can_not_move?(moderations)
      if moderations.any? { |moderation| !current_user.can?(:move_topics, moderation.topic) }
        flash[:notice] = t(:You_are_not_allowed_to_move_topics)
        redirect_back_or_default root_path
      end
    end
    
    def can_not_lock?(moderations)
      if !current_user.can?(:lock_topics)
        flash[:notice] = t(:You_are_not_allowed_to_lock_or_unlock_topics)
        redirect_back_or_default root_path
      end
    end
    
    def can_not_delete?(moderations)
      if !current_user.can?(:delete_topics)
        flash[:notice] = t(:You_are_not_allowed_to_delete_topics)
        redirect_back_or_default root_path
      end
    end
    
    def can_not_sticky?(moderations)
      if !current_user.can?(:sticky_topics)
        flash[:notice] = t(:You_are_not_allowed_to_sticky_or_unsticky_topics)
        redirect_back_or_default root_path
      end
    end
    
    def can_not_merge?(moderations)
      if !current_user.can?(:merge_topics)
        flash[:notice] = t(:You_are_not_allowed_to_merge_topics)
        redirect_back_or_default root_path
      end
    end
    
end