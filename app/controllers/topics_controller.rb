class TopicsController < ApplicationController
  before_filter :store_location, :only => [:show, :new, :edit, :reply]
  before_filter :login_required, :except => [:show]
  before_filter :find_forum
  before_filter :moderator_login_required, :only => [:lock, :unlock]
  
  def index
    redirect_to forum_path(@forum)
  end
  
  def show
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
    @topic = @forum.topics.new
    @post = @topic.posts.build
  end
  
  def create
    ip = Ip.find_or_create_by_ip(request.remote_addr)
    @topic = current_user.topics.build(params[:topic].merge(:forum => @forum, :ip => ip))
    @post = @topic.posts.build(params[:post].merge(:user => current_user, :ip => ip))
    @topic.sticky = true if params[:topic][:sticky] == 1 && current_user.admin?
    if @topic.save
      flash[:notice] = t(:topic_created)
      redirect_to forum_topic_path(@topic.forum, @topic)
    else
      flash[:notice] = t(:topic_not_created)
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
        if @topic.posts.first.update_attributes(params[:topic])
          flash[:notice] = t(:topic_updated)
          redirect_back_or_default forum_topic_path(@forum, @topic)
        else
          flash[:notice] = t(:post_not_updated)
          render :action => "edit"
        end
      else
        flash[:notice] = t(:topic_not_updated)
        render :action => "edit"
      end
    end
  end
  
  private
  
  def not_found
    flash[:notice] = t(:topic_not_found)
    redirect_to forums_path
  end
  
  private
  
  def find_forum
    @forum = Forum.find(params[:forum_id], :include => [:topics, :posts]) if params[:forum_id]
    if @forum.viewable?(current_user)
      @topic = @forum.topics.find(params[:id], :joins => :posts) if params[:id]
    else
      flash[:notice] = t(:not_allowed_to_view_topics)
      redirect_to root_path
    end
    rescue ActiveRecord::RecordNotFound
      not_found
  end
  
  def user_has_permission?
    @topic.belongs_to?(current_user) || current_user.admin?
  end
    
  def create_ip
    IpUser.create(:ip => Ip.find_or_create_by_ip(request.remote_addr), :user => current_user)
  end
  
end
