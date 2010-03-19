class Moderator::PostsController < Moderator::ApplicationController
  before_filter :find_topic

  # Magic for this method is in lib/array_ext.rb
  def split
    @post = @posts.find(params[:id])
    if request.post?
      @split_posts = case params[:direction]
        when "before"
          @posts.all_previous(@post)
        when "before_including"
          @posts.all_previous(@post, true)
        when "after_including"
          @posts.all_next(@post, true)
        when "after"
          @posts.all_next(@post)
        end
      if @split_posts.blank?
        flash[:notice] = t(:selection_yielded_no_posts)
        redirect_to split_moderator_topic_post_path(@topic, params[:id])
        return false
      end

      if @split_posts.size == @posts.size
        flash[:notice] = t(:cannot_take_all_posts_away)
        redirect_to split_moderator_topic_post_path(@topic, params[:id])
        return false
      end
      @subject = case params[:how]
        when "just_split"
          "[SPLIT] #{@topic.subject}"
        when "split_with_subject"
          "#{params[:subject]}"
        else
          @topic.subject
      end
      @new_topic = @topic.forum.topics.build(:subject => @subject, :user => @posts.first.user, :ip => @posts.first.ip)
      @new_topic.posts = @split_posts
      @new_topic.locked = @topic.locked
      @new_topic.sticky = @topic.sticky
      @new_topic.save
      flash[:notice] = t(:topic_has_been_split)
      redirect_to forum_topic_path(@new_topic.forum, @new_topic)
    else
      @previous_post = @posts.previous(@post)
      @next_post = @posts.next(@post)
    end
  end

  private

  def find_topic
    @topic = Topic.find(params[:topic_id], :joins => :posts)
    @posts = @topic.posts
  end
end