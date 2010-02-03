class PostsController < ApplicationController
  before_filter :login_required
  before_filter :find_topic
  before_filter :find_user, :only => [:index]
  before_filter :find_post, :only => [:edit, :update, :destroy]
  before_filter :can_post_here?, :except => [:index]
  before_filter :create_ip, :only => [:create, :update]

  def index
    @posts = @user.posts.paginate :per_page => per_page, :page => params[:page], :include => { :topic => :forum }
  end

  def new
    @posts = @topic.last_10_posts
    @post ||= @topic.posts.build(:user => current_user)
  end

  def create
    @post = @topic.posts.build(params[:post].merge!(:user => current_user, :ip => @ip))

    if @post.save
      flash[:notice] = t(:created, :thing => "Post")
      go_directly_to_post
    else
      # The last 10 posts for this topic
      @posts = @topic.last_10_posts
      @quoting_post = Post.find(params[:quote]) unless params[:quote].blank?
      flash.now[:notice] = t(:not_created, :thing => "post")
      render :action => "new"
    end
  end

  def edit
    @posts = @topic.posts.past(@post.created_at).last(10).reverse
  end

  def update
    @topic = @post.topic
    # Because *_changed? is reset AFTER update_attributes.
    # Grr.
    text_changed = @post.text != params[:post][:text]
    if @post.update_attributes(params[:post])
      if text_changed
        @post.edits.create(:original_content => @post.text,
                           :current_content => params[:post][:text],
                           :user => current_user,
                           :hidden => params[:silent_edit] == "1" && current_user.can?(:silently_edit, @forum),
                           :ip => create_ip)
        @post.update_attribute("edited_by", current_user)
      end
      flash[:notice] = t(:updated, :thing => "post")
      go_directly_to_post
    else
      flash.now[:notice] = t(:not_updated, :thing => "post")
      render :action => "edit"
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = t(:deleted, :thing => "post")
    if @post.topic.posts.count.zero?
      @post.topic.destroy
      flash[:notice] += t(:topic_too)
      redirect_to forum_path(@post.forum)
    else
      redirect_to forum_topic_path(@post.forum, @post.topic)
    end
  end

  # Not using the find_post method here because we're storing it as quoting_post.
  def reply
    if current_user.can?(:reply_to_topics)
      quoting_post = Post.find(params[:id])
      @post = @topic.posts.build(:user => current_user)
      @post.text = "[quote=\"#{quoting_post.user}\"]#{quoting_post.text}[/quote]\n"
      render :action => "new"
    else
      flash[:notice] = t(:can_not_reply)
      redirect_to forum_topic_path(@topic.forum, @topic)
    end

  end

  private

    def not_found
      flash[:notice] = t(:not_found, :thing => "post")
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

    def can_post_here?
      if !@topic.forum.open? && !current_user.can?(:post_in_closed_forums)
        flash[:notice] = t(:This_forum_is_closed)
        redirect_to root_path
      end
    end

    def find_user
      @user = User.find_by_permalink(params[:user_id])
    end

    def create_ip
      @ip = Ip.find_or_create_by_ip(request.remote_addr)
      IpUser.find_or_create_by_ip_id_and_user_id(@ip.id, current_user.id)
      @ip
    end

    def check_ownership
      if (@post.belongs_to?(current_user) && !current_user.can?(:edit_own_posts, @post.forum)) ||
         (!@post.belongs_to?(current_user) && !current_user.can?(:edit_posts, @post.forum))
        flash[:notice] = t(:Cannot_edit_post)
        redirect_back_or_default(forums_path)
      end
    end

    def go_directly_to_post
      redirect_to forum_topic_path(@post.forum,@topic) + "/#{@post.page_for(current_user)}" + "#post_#{@post.id}"
    end
end