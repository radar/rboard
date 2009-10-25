class TopicsController < ApplicationController
  before_filter :store_location, :only => [:show, :new, :edit, :reply]
  before_filter :login_required, :except => [:show, :index]
  before_filter :find_forum
  before_filter :can_post_here?, :except => [:show, :index]
  before_filter :create_ip, :only => [:create, :update]
  
  def index
    redirect_to forum_path(@forum)
  end
  
  def show
    if logged_in?
      readers = @topic.readers
      readers << current_user if !readers.include?(current_user)
      @subscription = current_user.subscriptions.find_by_topic_id(params[:id])
      @subscription.update_attribute("posts_count", 0) if @subscription
    end
    @posts = @topic.posts.finished.paginate :per_page => per_page, :page => params[:page], :include => :user
    @topic.increment!("views")
    @post = Post.new
    respond_to do |format|
      format.html
      format.rss
    end
  end
  
  def new
    @topic = @forum.topics.new
    @post = @topic.posts.build
  end
  
  def create
    @topic = current_user.topics.build(params[:topic].merge(:forum => @forum, :ip => @ip))
    @post = @topic.posts.build(params[:post].merge(:user => current_user, :ip => @ip))
    
    # Automatic non-mass-assignables
    # BUZZWORD BINGO!
    @topic.sticky = true if params[:topic][:sticky] && current_user.can?(:post_stickies)
    if !params[:attachments]
      @topic.finished = true
      @post.finished = true
    end
    
    @topic.subscriptions.build(:user => current_user) if current_user.can?(:subscribe, @forum) && current_user.auto_subscribe? 
    
    if @topic.save && @post.save
      if params[:attachments] && current_user.can?(:use_attachments, @forum)
        flash[:notice] = t(:Now_you_may_attach_files)
        redirect_to topic_post_attachments_path(@topic, @post)
      else
        flash[:notice] = t(:created, :thing => "Topic")
        redirect_to forum_topic_path(@topic.forum, @topic)
      end
    else
      flash[:notice] = t(:not_created, :thing => "Topic")
      render :action => "new"
    end
  end
  
  def edit
    @post = @topic.posts.first
    if !user_has_permission?
      flash[:notice] = t(:not_allowed_to_edit_topic)
      redirect_to forum_topic_path(@forum, @topic)
    end
  end
  
  def update
    if !user_has_permission?
      flash[:notice] = t(:not_allowed_to_edit_topic)
      redirect_to forum_topic_path(@forum, @topic)
    else
      if @topic.update_attributes(params[:topic])
        if @topic.posts.first.update_attributes(params[:post])
          flash[:notice] = t(:updated, :thing => "topic")
          redirect_back_or_default forum_topic_path(@forum, @topic)
        else
          flash.now[:notice] = t(:not_updated, :thing => "post")
          render :action => "edit"
        end
      else
        flash.now[:notice] = t(:not_updated, :thing => "topic")
        render :action => "edit"
      end
    end
  end
  
  private
  
  def not_found
    flash[:notice] = t(:not_found, :thing => "topic")
    redirect_to forums_path
    nil # For later on when we need it in find_forum
  end
  
  private
  
  def find_forum
    if params[:forum_id]
      @forum = Forum.find(params[:forum_id], :include => :topics)
      if current_user.can?(:see_forum, @forum)
        @topic = find_topic(@forum.topics) if params[:id]
      else
        flash[:notice] = t(:forum_permission_denied)
        redirect_to root_path
      end
    else
      @topic = find_topic
      # Replace with rendered_or_redirected or whatever the hell it is
      redirect_to forum_topic_path(@topic.forum, @topic) unless performed?
    end
  end
  
  def find_topic(topics=Topic)
    topic_options = { :include => [:reports, :posts] }
    return topics.find(params[:id], topic_options)
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  def can_post_here?
    if !@forum.open? && !current_user.can?(:post_in_closed_forums)
      flash[:notice] = t(:This_forum_is_closed)
      redirect_to root_path
    end
  end
    
  
  def user_has_permission?
    current_user.can?(:edit_topics, @forum) || (current_user.can?(:edit_own_topics, @forum) && @topic.belongs_to?(current_user))
  end
    
  def create_ip
    @ip = Ip.find_or_create_by_ip(request.remote_addr)
    IpUser.create(:ip => @ip, :user => current_user)
  end
  
end
