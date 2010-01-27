class Moderator::ModerationsController < Moderator::ApplicationController
  before_filter :find_topic_or_post
  before_filter :store_location, :only => :index
  before_filter :find_moderation, :only => [:edit, :update]

  def index
    @topic_moderations = Moderation.topics.for_user(current_user)
    @post_moderations = Moderation.posts.for_user(current_user)
    @all_forums = Forum.all.select { |forum| current_user.can?(:see_forum, forum) }
  end

  # Checks to see if the moderation already exists and if it does will destroy it
  # If the moderation does not exist, then it will create one.
  def create
    moderations = @thing.moderations
    @moderation = moderations.for_user(current_user).first
    if @moderation.nil?
      forum = @thing.forum
      moderations.create(:user => current_user, :forum => forum)
      @moderated_topics_count = forum.moderations.topics.for_user(current_user).count
    else
      destroy
      render :action => :destroy
    end
  end

  def edit

  end

  def update
    if @moderation.update_attributes(params[:moderation])
      flash[:notice] = t(:updated, :thing => "moderation")
      redirect_to moderator_moderations_path
    else
      flash[:notice] = t(:not_updated, :thing => "moderation")
      render :action => "edit"
    end
  end

  # Can be called from the create action for when a moderation already exists.
  # Used primarily for unchecking box on forums/show topics listing.
  def destroy
    @moderation ||= Moderation.find(params[:id])
    @moderation.destroy
    @moderated_topics_count = @moderation.moderated_object.forum.moderations.topics.for_user(current_user).count
  end

  # Used for moving a topic, or selection of topics.
  def move

  end

  private
    def find_moderation
      @moderation = Moderation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      not_found
    end

    def find_topic_or_post
      @thing = Topic.find(params[:topic_id]) unless params[:topic_id].nil?
      @thing ||= Post.find(params[:post_id]) unless params[:post_id].nil?
    end

    def not_found
      flash[:notice] = t(:not_found, :thing => "moderation")
      redirect_to moderator_moderations_path
    end
end