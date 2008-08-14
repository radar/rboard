class PostsController < ApplicationController
  before_filter :login_required
  
  def new
     @topic = Topic.find(params[:topic_id], :include => :posts)
     #is there an easier way to do this?
     @posts = @topic.last_10_posts
     @post = @topic.posts.build(:user => current_user)
     if params[:quote]
       @quoting_post = Post.find(params[:quote])
       @post.text = "[quote=\"" + @quoting_post.user.login + "\"]" + @quoting_post.text + "[/quote]"
     end
   end

  def create
    @topic = Topic.find(params[:topic_id], :include => :posts)
    @posts = @topic.posts.find(:all, :order => "id DESC", :limit => 10)
    @post = @topic.posts.build(params[:post].merge!(:user => current_user))
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
    unless is_post_owner_or_admin?(params[:id])
      flash[:notice] = "You do not own that post."
      redirect_back_or_default(forums_path)
    else
      render :layout => false
    end
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post has been updated."
    else
      flash[:notice] = "This post could not be updated."
    end
  rescue ActiveRecord::RecordNotFound
    not_found
  end
  
  def destroy
    @post = Post.find(params[:id]).destroy
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
  
end