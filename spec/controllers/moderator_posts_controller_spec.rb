require File.dirname(__FILE__) + '/../spec_helper'

describe Moderator::PostsController do
  
  fixtures :posts, :topics, :users, :groups, :group_users, :permissions
  
  before do
    login_as(:moderator)
    @topic = mock_model(Topic)
    @topics = [@topic]
    @post = mock_model(Post)
    @posts = [@post, @post]
    @forum = mock_model(Forum)
    @user = mock_model(User)
    Topic.should_receive(:find).and_return(@topic)
  end
  
  def split
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:find).and_return(@post)
  end
  
  def split_success
    @topic.should_receive(:forum).twice.and_return(@forum)
    @forum.should_receive(:topics).and_return(@topics)
    @post.should_receive(:user).and_return(@user)
    @topics.should_receive(:create).and_return(@topic)
    @topic.should_receive(:posts=).and_return(@posts)
  end
  
  it "should be able to begin to split a post" do
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:find).and_return(@post)
    @posts.should_receive(:previous).and_return(@post)
    @posts.should_receive(:next).and_return(@post) 
    get 'split', :id => 1
  end
  
  it "shouldn't be able to split a topic before the first post" do
     split
     @posts.should_receive(:all_previous).with(@post).and_return(nil)
     post 'split', { :id => 1, :direction => "before", :how => "just_split", :topic_id => 1 }
     response.should redirect_to(split_moderator_topic_post_path(@topic, 1))
     flash[:notice].should eql(t(:selection_yielded_no_posts))
   end
  
  it "should be able to split a topic before" do
    split
    split_success
    @topic.should_receive(:subject).and_return("Subject") 
    @posts.should_receive(:all_previous).with(@post).and_return([@post])
    post 'split', { :id => 1, :direction => "before", :how => "just_split", :topic_id => 1 }
    response.should redirect_to(forum_topic_path(@forum, @topic))    
  end
  
  it "should be able to split a topic before and including a specific post" do
    split
    split_success
    @topic.should_receive(:subject).and_return("Subject")
    @posts.should_receive(:all_previous).with(@post, true).and_return(@posts + [@post])
    post 'split', { :id => 1, :direction => "before_including", :how => "just_split", :topic_id => 1 }
    response.should redirect_to(forum_topic_path(@forum, @topic))    
  end
  
  it "should be able to split a topic after and including a specific post" do
    split
    split_success
    @topic.should_receive(:subject).and_return("Subject")
    @posts.should_receive(:all_next).with(@post, true).and_return(@posts + [@post])
    post 'split', { :id => 1, :direction => "after_including", :how => "just_split", :topic_id => 1 }
    response.should redirect_to(forum_topic_path(@forum, @topic))
  end
  
  it "should be able to split a topic after a specific post" do
    split
    split_success
    @topic.should_receive(:subject).and_return("Subject")
    @posts.should_receive(:all_next).with(@post).and_return([@post])
    post 'split', { :id => 2, :direction => "after", :how => "just_split", :topic_id => 1 }
    response.should redirect_to(forum_topic_path(@forum, @topic))
  end
  
  it "should be able to split a topic before and including a specific post and change subject" do
    split
    split_success
    @posts.should_receive(:all_previous).with(@post, true).and_return(@posts + [@post])
    post 'split', { :id => 1, :direction => "before_including", :how => "split_with_subject", :subject => "puppies", :topic_id => 1 }
    response.should redirect_to(forum_topic_path(@forum, @topic))    
  end
  
  it "should not be able to split a topic after a specific post if there are no posts" do
    split
    @posts.should_receive(:all_next).with(@post).and_return(@posts)
    post 'split', { :id => 1, :direction => "after", :how => "just_split" }
    flash[:notice].should eql(t(:cannot_take_all_posts_away))
    response.should redirect_to(split_moderator_topic_post_path(@topic, 1))
  end

end