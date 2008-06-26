class TopicsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :find_forum
  before_filter :is_viewable?, :only => [:show]
  before_filter :create_topic_redirect, :only => [:new, :create]
  before_filter :store_location, :only => [:show, :new, :edit, :reply]
  
  def new
    @topic = Topic.new
  end
  
  def create
    Topic.transaction do
      @topic = current_user.topics.create!(params[:topic].merge(:forum_id => params[:forum_id]))
      @post = @topic.posts.create!(params[:post].merge(:user_id => current_user.id ))
      @topic.sticky = true if params[:topic][:sticky] == 1 && is_admin?
    end
    flash[:notice] = "Topic has been created."
    redirect_to forum_topic_path(@topic.forum, @topic)
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => @e
    flash[:notice] = "Topic was not created."
    #So it doesn't forget the post text
    @post = current_user.posts.new(params[:post])
    render :template => "topics/new"
  end
  
  def show
    @topic ||= Topic.find(params[:id], :include => [:forum])
    @topic.increment!("views")
  end
  
  def reply
    @topic = Topic.find(params[:id])
    #is there an easier way to do this?
    @posts = @topic.posts.reverse.last(10)
    @quoting_post = Post.find(params[:quote]) if params[:quote]
    @post = Post.new(:topic_id => params[:id])
  end
  
  def moderate
    case params[:commit]
    when "Lock"
      params[:moderated_topics].each { |id| Topic.find(id).update_attribute("locked",true) }
      flash[:notice] = "All selected topics have been locked."
    when "Unlock"
      params[:moderated_topics].each { |id| Topic.find(id).update_attribute("locked",false) }
      flash[:notice] = "All selected topics have been unlocked."
    when "Delete"
      #TODO: maybe ask for confirmation?
      params[:moderated_topics].each { |id| Topic.find(id).destroy }
      flash[:notice] = "All selected topics have been deleted."
    when "Sticky"
      params[:moderated_topics].each { |id| Topic.find(id).update_attribute("sticky",true) }
    when "Unsticky"
      params[:moderated_topics].each { |id| Topic.find(id).update_attribute("sticky",false) }
    end
    redirect_to forum_path(params[:forum_id])
  end
  
  #these two methods do basically the same thing
  def lock
    topic = Topic.find(params[:id])
    topic.update_attribute("locked",true)
    flash[:notice] = "This topic has been locked."
    redirect_to topic_path(topic)
  end
  
  def unlock
    topic = Topic.find(params[:id])
    topic.update_attribute("locked",false)
    flash[:notice] = "This topic has been unlocked."
    redirect_to topic_path(topic)
  end

  private
  
  def can_reply?
    true
  end
  
  def is_viewable?
    @topic = Topic.find(params[:id], :include => [:forum])
    @forum = @topic.forum
    unless (logged_in? && @forum.is_visible_to < current_user.user_level_id) || @forum.is_visible_to == 1
      flash[:notice] = "You do not have the permissions to access that topic."
      redirect_back_or_default(forums_path)
    end
  end
  
  def create_topic_redirect
    @forum = Forum.find(params[:forum_id])
    if current_user.user_level_id < @forum.topics_created_by
      flash[:notice] = "You do not have permissions to create topics in this forum."
      redirect_back_or_default(forums_path)
    end
  end
  
  def find_forum
    @forum = Forum.find(params[:forum_id]) if params[:forum_id]
  end
  
end
