require File.dirname(__FILE__) + '/../../spec_helper'

describe Moderator::PostsController do

  before do
    setup_user_base
    setup_forums
    login_as(:moderator)
    @forum = Forum("Public Forum")
    valid_topic_for(@forum, 3)
    @topic = @forum.topics.first
    @first_post = @topic.posts.first
    @second_post = @topic.posts.second
  end

  def topic_split
    flash[:notice].should eql(t(:topic_has_been_split))
  end

  it "should be able to begin to split a post" do
    get 'split', { :id => @first_post.id, :topic_id => @topic.id }
    response.should render_template("split")
  end

  it "shouldn't be able to split a topic before the first post" do
     post 'split', { :id => @first_post.id, :direction => "before", :how => "just_split", :topic_id => @topic.id }
     response.should redirect_to(split_moderator_topic_post_path(@topic, @first_post.id))
     flash[:notice].should eql(t(:selection_yielded_no_posts))
   end

  it "should be able to split a topic before" do
    post 'split', { :id => @second_post.id, :direction => "before", :how => "just_split", :topic_id => @topic.id }
    topic_split
    response.should redirect_to(forum_topic_path(@forum, assigns[:new_topic].id))
  end

  it "should be able to split a topic before and including a specific post" do
    post 'split', { :id => @second_post.id, :direction => "before_including", :how => "just_split", :topic_id => @topic.id }
    topic_split
    response.should redirect_to(forum_topic_path(@forum, assigns[:new_topic].id))    
  end

  it "should be able to split a topic after and including a specific post" do
    post 'split', { :id => @second_post.id, :direction => "after_including", :how => "just_split", :topic_id => @topic.id }
    topic_split
    response.should redirect_to(forum_topic_path(@forum, assigns[:new_topic].id))
  end

  it "should be able to split a topic after a specific post" do
    post 'split', { :id => @second_post.id, :direction => "after", :how => "just_split", :topic_id => @topic.id }
    topic_split
    response.should redirect_to(forum_topic_path(@forum, assigns[:new_topic].id))
  end

  it "should be able to split a topic before and including a specific post and change subject" do
    post 'split', { :id => @second_post.id, :direction => "before_including", :how => "split_with_subject", :subject => "puppies", :topic_id => @topic.id }
    topic_split
    response.should redirect_to(forum_topic_path(@forum, assigns[:new_topic].id))    
  end

  it "should not be able to split a topic after a specific post if there are no posts" do
    post 'split', { :id => @first_post.id, :direction => "after_including", :how => "just_split", :topic_id => @topic.id }
    flash[:notice].should eql(t(:cannot_take_all_posts_away))
    response.should redirect_to(split_moderator_topic_post_path(@topic, @first_post.id))
  end

end