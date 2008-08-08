class TopicsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :find_forum
  before_filter :is_viewable?, :only => [:show, :unlock, :lock, :moderate]
  before_filter :create_topic_redirect, :only => [:new, :create]
  before_filter :store_location, :only => [:show, :new, :edit, :reply]
  before_filter :moderator_login_required, :only => [:moderate, :lock, :unlock]
  
  def show
     @topic ||= Topic.find(params[:id])
     @topic.increment!("views")
   end
  
  def new
    @topic = Topic.new
    @post = @topic.posts.build
  end
  
  def create
    @topic = current_user.topics.build(params[:topic].merge(:forum_id => params[:forum_id]))
    @post = @topic.posts.build(params[:post].merge(:user_id => current_user.id))
    @topic.sticky = true if params[:topic][:sticky] == 1 && current_user.admin?
    if @topic.save
      flash[:notice] = "Topic has been created."
      redirect_to forum_topic_path(@topic.forum, @topic)
    else
      flash[:notice] = "Topic was not created."
      render :action => "new"
    end
  end
  
  def reply
    @topic = Topic.find(params[:id])
    #is there an easier way to do this?
    @posts = @topic.last_10_posts
    @post = @topic.posts.build(:user => current_user)
    if params[:quote]
      @quoting_post = Post.find(params[:quote])
      @post.text = "[quote=\"" + @quoting_post.user.login + "\"]" + @quoting_post.text + "[/quote]"
    end
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
        flash[:notice] = "All selected topics have been stickied."
      when "Unsticky"
        params[:moderated_topics].each { |id| Topic.find(id).update_attribute("sticky",false) }
        flash[:notice] = "All selected topics have been unstickied."
    end
    redirect_to forum_path(@forum)
  end
  
  #these two methods do basically the same thing
  def lock
    topic = Topic.find(params[:id])
    topic.update_attribute("locked",true)
    flash[:notice] = "This topic has been locked."
    redirect_to forum_topic_path(topic.forum, topic)
  end
  
  def unlock
    topic = Topic.find(params[:id])
    topic.update_attribute("locked",false)
    flash[:notice] = "This topic has been unlocked."
    redirect_to forum_topic_path(topic.forum, topic)
  end

  private
  
  def is_viewable?
    if !@forum.viewable?(logged_in?, current_user)
      flash[:notice] = "You are not allowed to see topics in this forum."
      redirect_back_or_default(forums_path)
    end
  end
  
  def create_topic_redirect
    @forum = Forum.find(params[:forum_id])
    if !@forum.topics_creatable_by?(logged_in?, current_user)
      flash[:notice] = "You are not allowed to create topics in this forum."
      redirect_back_or_default(forums_path)
    end
  end
  
  def find_forum
    @forum = Forum.find(params[:forum_id]) if params[:forum_id]
  end
  
end
