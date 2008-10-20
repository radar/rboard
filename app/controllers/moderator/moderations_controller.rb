class Moderator::ModerationsController < Moderator::ApplicationController
  before_filter :find_topic_or_post
  
  def index
    @moderations = Moderation.for_user(current_user)
  end
  
  def new
    
  end
  
  def edit
    @moderation = Moderation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  def update
    @moderation = Moderation.find(params[:id])
    if @moderation.update_attributes(params[:moderation])
      flash[:notice] = "The selected moderation has been updated."
      redirect_to moderator_moderations_path
    else
      flash[:notice] = "The selected moderation could not be updated."
      render :action => "edit"
    end
  rescue ActiveRecord::RecordNotFound
    not_found
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
    
    def not_found
      flash[:notice] = "The moderation you were looking for could not be found."
      redirect_to moderator_moderations_path
    end
end