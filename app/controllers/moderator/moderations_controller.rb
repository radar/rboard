class Moderator::ModerationsController < Moderator::ApplicationController
  before_filter :find_topic_or_post
  
  def index
    @moderations = Moderation.for_user(current_user)
  end
  
  def new
    
  end
  
  def moderate
    case params[:commit]
      when "Lock"
        Moderation.topics.for_user(current_user.id).each do |m|
           m.moderated_object.lock!
           m.destroy
        end
        flash[:notice] = "All selected topics have been locked."
      when "Unlock"
        Moderation.topics.for_user(current_user.id).each do |m|
           m.moderated_object.unlock!
           m.destroy
        end
        flash[:notice] = "All selected topics have been unlocked."
      when "Delete"
        #TODO: maybe ask for confirmation?
        Moderation.topics.for_user(current_user.id).each do |m|
          m.moderated_object.destroy
          m.destroy
        end
        flash[:notice] = "All selected topics have been deleted."
      when "Sticky"
        Moderation.topics.for_user(current_user.id).each do |m|
          m.moderated_object.sticky!
          m.destroy
        end
        flash[:notice] = "All selected topics have been stickied."
      when "Unsticky"
        Moderation.topics.for_user(current_user.id).each do |m|
          m.moderated_object.unsticky!
          m.destroy
        end
        flash[:notice] = "All selected topics have been unstickied."
      when "Move"
        move(Moderation.topics.for_user(current_user.id).map(&:moderated_object))
        return false
    end
    redirect_back_or_default(root_path)
  end
  
  # Checks to see if the moderation already exists and if it does will destroy it
  # If the moderation does not exist, then it will create one.
  def create
    @moderation = @thing.moderations.for_user(current_user).first
    if @moderation.nil?
      @thing.moderations.create(:user => current_user, :forum => @thing.forum)
      @moderated_topics_count = @thing.forum.moderations.topics.count
    else
      destroy
      render :action => :destroy
    end
  end
  
  def destroy
    @moderation ||= Moderation.find(params[:id])
    @moderation.destroy
    @moderated_topics_count = @moderation.moderated_object.forum.moderations.topics.count
  end
  
  private
  
    def find_topic_or_post
      @thing = Topic.find(params[:topic_id]) unless params[:topic_id].nil?
      @thing ||= Post.find(params[:post_id]) unless params[:post_id].nil?
    end
end