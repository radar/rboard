class Moderator::TopicsController < Moderator::ApplicationController
  before_filter :find_topic, :except => [:moderate]
  
  def destroy
    @topic.destroy
    flash[:notice] = "That topic has been deleted."
    redirect_back_or_default moderator_moderations_path
  end
  
  # This method works in two ways.
  # The first way is from the moderations index action which will pass in params[:moderation_ids] if
  # any of the submit buttons on the bottom row are clicked.
  #
  # The second comes from forums/show which will use all the currently selected moderations as the objects.
  def moderate
    @moderations_for_topics = Moderation.for_user(current_user).topics.find(params[:moderation_ids]) if params[:moderation_ids]
    @moderations_for_topics ||= Moderation.topics.for_user(current_user.id)
    case params[:commit]
      when "Lock"
        @moderations_for_topics.each { |m| m.lock! }
        flash[:notice] = "All selected topics have been locked."
      when "Unlock"
        @moderations_for_topics.each { |m| m.unlock! }
        flash[:notice] = "All selected topics have been unlocked."
      when "Delete"
        #TODO: maybe ask for confirmation?
        @moderations_for_topics.each { |m| m.destroy! }
        flash[:notice] = "All selected topics have been deleted."
      when "Sticky"
        @moderations_for_topics.each { |m| m.sticky! }
        flash[:notice] = "All selected topics have been stickied."
      when "Unsticky"
        @moderations_for_topics.each { |m| m.unsticky! }
        flash[:notice] = "All selected topics have been unstickied."
      when "Move"
        move
        return false
    end
    redirect_back_or_default(root_path)
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = "The moderation you were looking for could not be found."
    redirect_back_or_default moderator_moderations_path
  end
  
  def move
    if params[:new_forum_id]
      @moderations_for_topics.each { |m| m.move!(params[:new_forum_id]) }
      flash[:notice] = "The selected topics have been moved."
      redirect_back_or_default(forum_path(params[:new_forum_id]))
    else
      render
    end
  end
  
  def toggle_lock
    @topic.toggle!("locked")
    flash[:notice] = "This topic has been " + (@topic.locked? ? "locked." : "unlocked.")
    redirect_back_or_default moderator_moderations_path
  end
  
  def toggle_sticky
    @topic.toggle!("sticky")
    flash[:notice] = "This topic has been " + (@topic.sticky? ? "stickied." : "unstickied.")
    redirect_back_or_default moderator_moderations_path
  end
  
  private
    def find_topic
      @topic = Topic.find(params[:id])
      
      # If the user is not allowed to see the topic, then they must not be allowed to change it either.
      if !@topic.forum.viewable?(true, current_user)
        flash[:notice] = "You are not allowed to access that topic."
        @topic.moderations.for_user(current_user).each { |m| m.destroy }
        redirect_to moderator_moderations_path
      end
      
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "The topic you were looking for could not be found."
        redirect_to moderator_moderations_path
    end
  
end