class TopicsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :find_forum
  before_filter :is_viewable?, :only => [:show, :unlock, :lock, :moderate]
  before_filter :create_topic_redirect, :only => [:new, :create]
  before_filter :store_location, :only => [:show, :new, :edit, :reply]
  before_filter :moderator_login_required, :only => [:moderate, :lock, :unlock]
  
  def show
     @topic = @forum.old_topics.find(params[:id], :include => [:posts])
     if is_admin?
       @posts = @topic.posts
     else
       @posts = @topic.user_posts
     end    
     @posts = @posts.paginate :per_page => 30, :page => params[:page], :include => [:topic, { :user => :user_level }]
     @topic.increment!("views")
   rescue ActiveRecord::RecordNotFound
     not_found
   end
  
  def new
    check_ownership
    puts "I SHOULD NEVER APPEAR"
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
  
  def moderate
    case params[:commit]
      when "Lock"
        params[:moderated_topics].each { |id| Topic.find(id).lock! }
        flash[:notice] = "All selected topics have been locked."
      when "Unlock"
        params[:moderated_topics].each { |id| Topic.find(id).unlock! }
        flash[:notice] = "All selected topics have been unlocked."
      when "Delete"
        #TODO: maybe ask for confirmation?
        params[:moderated_topics].each { |id| Topic.find(id).destroy }
        flash[:notice] = "All selected topics have been deleted."
      when "Sticky"
        params[:moderated_topics].each { |id| Topic.find(id).sticky! }
        flash[:notice] = "All selected topics have been stickied."
      when "Unsticky"
        params[:moderated_topics].each { |id| Topic.find(id).unsticky! }
        flash[:notice] = "All selected topics have been unstickied."
      when "Move"
        session[:topic_ids] = params[:moderated_topics]
        move
        return false
    end
    redirect_to forum_path(@forum)
  end
  
  def move
    ids = [params[:id]]
    ids = session[:topic_ids] if ids.flatten.empty?
    @topics = Topic.find(params[:id] || session[:topic_ids])
    @forums = Forum.find(:all, :select => "id, title", :order => "title")
    if request.post?
      @topics.each { |topic| topic.move!(params[:new_forum_id]) }
      if @topics.size > 1
        flash[:notice] = "The selected topics have been moved."
        redirect_to forum_path(@forum)
      else
        flash[:notice] = "The selected topic has been moved."
        redirect_to forum_topic_path(@topics.first.forum, @topics.first)
      end
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
  
  def check_ownership
     redirect_to root_path and return false
  end
  
  def find_forum
    @forum = Forum.find(params[:forum_id]) if params[:forum_id]
  end
  
end
