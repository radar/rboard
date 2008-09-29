class PostsController < ApplicationController
  before_filter :login_required
  before_filter :find_topic
  
  def new
    @posts = @topic.last_10_posts
    @post = @topic.posts.build(:user => current_user)
    if params[:quote]
      @quoting_post = Post.find(params[:quote])
      @post.text = "[quote=\"" + @quoting_post.user.login + "\"]" + @quoting_post.text + "[/quote]"
    end
  end

  def create
    @topic = Topic.find(params[:topic_id], :include => :posts)
    @posts = @topic.posts
    @posts = @posts.find(:all, :order => "id DESC", :limit => 10)
    @post = @posts.build(params[:post].merge!(:user => current_user))
    if @post.save
      @topic.update_attribute("last_post_id", @post.id)
      page = (@topic.posts.size.to_f / 30).ceil
      flash[:notice] = "Post has been created."
      redirect_to forum_topic_path(@post.forum,@topic, :page => page)
    else
      @quoting_post = Post.find(params[:quote]) unless params[:quote].blank?
      flash[:notice] = "This post could not be created."
      render :action => "new"
    end
  end
   
  def edit
    @post = Post.find(params[:id])
    check_ownership
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  def update
    @post = Post.find(params[:id])
    check_ownership
    @topic = @post.topic
    if (@post != @topic.posts.last && params[:post][:text] != @post.text) && (!is_admin? || (is_admin? && params[:silent_edit] != "1"))
      edit = @post.edits.create(:original_content => @post.text, :current_content => params[:post][:text], :user => current_user, :ip => request.remote_addr)
    end
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post has been updated."
      redirect_to forum_topic_path(@topic.forum, @topic)
    else
      flash[:notice] = "This post could not be updated."
      render :action => "edit"
    end
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "Post was deleted."
    if @post.topic.posts.size.zero?
      @post.topic.destroy
      flash[:notice] += " This was the only post in the topic, so topic was deleted also."
      redirect_to forum_path(@post.forum)
    else
      redirect_to forum_topic_path(@post.forum, @post.topic)
    end
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  private
    def not_found
      flash[:notice] = "The post you were looking for could not be found."
      redirect_back_or_default(forums_path)
    end
    
    def find_topic
      @topic = Topic.find(params[:topic_id]) unless params[:topic_id].nil?
    end
    
    def check_ownership
      unless @post.user == current_user || is_admin?
        flash[:notice] = "You do not own that post."
        redirect_back_or_default(forums_path)
      end
    end
end