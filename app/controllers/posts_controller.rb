class PostsController < ApplicationController
  #TODO: Rescue on error where needed.
  before_filter :login_required
  def edit
    @post = Post.find(params[:id])
    unless is_post_owner_or_admin?(params[:id])
      flash[:notice] = "You do not own that post."
      redirect_back_or_default(forums_path)
    end
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post has been updated."
    else
      flash[:notice] = "This post could not be updated."
    end
  end
  
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(params[:post])
    if @post.save
      flash[:notice] = "Post has been created."
      redirect_to forum_topic_path(@post.forum.id,@post.topic.id)
    else
      @posts = @topic.posts.reverse.last(11) - [@post]
      @quoting_post = Post.find(params[:quote]) if !params[:quote].blank?
      flash[:notice] = "This post could not be created."
      render :action => "../topics/reply"
    end
  end
  
  def destroy
    @post = Post.find(params[:id]).destroy
    flash[:notice] = "Post was deleted."
    if @post.topic.posts.size.zero?
      @post.topic.destroy
      flash[:notice] = "Post was deleted. This was the only post in the topic, so topic was deleted also."
    end
  end
  
end