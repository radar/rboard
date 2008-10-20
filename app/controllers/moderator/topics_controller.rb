class Moderator::TopicsController < Moderator::ApplicationController
  before_filter :find_topic
  
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
  
  def destroy
    @topic.destroy
    flash[:notice] = "That topic has been deleted."
    redirect_back_or_default moderator_moderations_path
  end
  
  def moderate
    @moderations_for_topics = Moderation.topics.for_user(current_user.id)
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
        render :action => "move"
        return false
    end
    redirect_back_or_default(root_path)
  end
  
  private
    def find_topic
      @topic = Topic.find(params[:id])
    end
  
end