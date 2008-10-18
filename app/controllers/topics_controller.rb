class TopicsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :find_forum
  before_filter :is_viewable?, :only => [:show, :unlock, :lock, :moderate]
  before_filter :create_topic_redirect, :only => [:new, :create]
  before_filter :store_location, :only => [:show, :new, :edit, :reply]
  before_filter :moderator_login_required, :only => [:moderate, :lock, :unlock]
  
  def index
    redirect_to forum_path(@forum)
  end
  
  def show
     @topic = @forum.topics.find(params[:id], :joins => :posts)
     @posts = @topic.posts.paginate :per_page => per_page, :page => params[:page], :include => { :user => :user_level }
     @topic.increment!("views")
     @post = Post.new
     respond_to do |format|
       format.html
       format.rss
     end
   rescue ActiveRecord::RecordNotFound
     not_found
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
      @topic.update_attribute("last_post_id", @post.id)
      flash[:notice] = "Topic has been created."
      redirect_to forum_topic_path(@topic.forum, @topic)
    else
      flash[:notice] = "Topic was not created."
      render :action => "new"
    end
  end
  
  #these two methods do basically the same thing
  def lock
    topic = Topic.find(params[:id])
    topic.lock!
    flash[:notice] = "This topic has been locked."
    redirect_to forum_topic_path(topic.forum, topic)
  end
  
  def unlock
    topic = Topic.find(params[:id])
    topic.unlock!
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
  
  def not_found
    flash[:notice] = "The topic you were looking for could not be found."
    redirect_to forums_path
  end
  
  def create_topic_redirect
    @forum = Forum.find(params[:forum_id])
    if !@forum.topics_creatable_by?(logged_in?, current_user)
      flash[:notice] = "You are not allowed to create topics in this forum."
      redirect_back_or_default(forums_path)
    end
  end
  
  private
  
  def find_forum
    @forum = Forum.find(params[:forum_id], :include => [:topics, :posts]) if params[:forum_id]
  end
  
end
