class PostsController < ApplicationController
  before_filter :login_required
  before_filter :find_topic
  before_filter :find_post, :only => [:edit, :update, :destroy]
  before_filter :create_ip, :only => [:create, :update]
  
  def index
    @posts = current_user.posts.paginate :per_page => per_page, :page => params[:page]
    
  end
  
  def new
    @posts = @topic.last_10_posts
    @post ||= @topic.posts.build(:user => current_user)
  end

  def create
    @topic = Topic.find(params[:topic_id], :include => :posts)
    posts = @topic.posts
    @posts = posts.find(:all, :order => "id DESC", :limit => 10)
    
    @post = @topic.posts.build(params[:post].merge!(:user => current_user, :ip => @ip))
    
    if @post.save
      @topic.set_last_post
      flash[:notice] = t(:post_created)
      go_directly_to_post
    else
      @quoting_post = Post.find(params[:quote]) unless params[:quote].blank?
      flash.now[:notice] = t(:post_not_created)
      render :action => "new"
    end
  end
   
  def edit
  end
  
  def update
    @topic = @post.topic
    if @post.update_attributes(params[:post])
      if @post.text_changed?
        @post.edits.create(:original_content => @post.text,
                           :current_content => params[:post][:text],
                           :user => current_user, 
                           :ip => request.remote_addr,
                           :hidden => params[:silent_edit] == "1",
                           :ip => @ip)
        @post.update_attribute("edited_by", current_user)
      end
      flash[:notice] = t(:post_updated)
      go_directly_to_post
    else
      flash.now[:notice] = t(:post_not_updated)
      render :action => "edit"
    end
  end
  
  def destroy
    @post.destroy
    flash[:notice] = t(:post_was_deleted)
    if @post.topic.posts.size.zero?
      @post.topic.destroy
      flash[:notice] += t(:topic_too)
      redirect_to forum_path(@post.forum)
    else
      redirect_to forum_topic_path(@post.forum, @post.topic)
    end
  end
  
  # Not using the find_post method here because we're storing it as quoting_post.
  def reply
    quoting_post = Post.find(params[:id])
    @post = @topic.posts.build(:user => current_user)
    @post.text = "[quote=\"#{quoting_post.user}\"]#{quoting_post.text}[/quote]"
    render :action => "new"
  end
  
  private
  
    def not_found
      flash[:notice] = t(:post_does_not_exist)
      redirect_back_or_default(forums_path)
    end
    
    def find_topic
      @topic = Topic.find(params[:topic_id], :include => :posts) unless params[:topic_id].nil?
    end
    
    def find_post
      @post = Post.find(params[:id])
      check_ownership
    rescue ActiveRecord::RecordNotFound
      not_found
    end
    
    def create_ip
      @ip = Ip.find_or_create_by_ip(request.remote_addr)
      IpUser.create(:ip => @ip, :user => current_user)
    end
    
    def check_ownership
      unless @post.belongs_to?(current_user) || is_moderator?
        flash[:notice] = "You do not own that post."
        redirect_back_or_default(forums_path)
      end
    end
    
    def go_directly_to_post
      page = (@topic.posts.count.to_f / per_page).ceil
      redirect_to forum_topic_path(@post.forum,@topic) + "/#{page}" + "#post_#{@post.id}"
    end
end