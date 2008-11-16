require File.dirname(__FILE__) + '/../spec_helper'

describe Moderator::PostsController do
  
  fixtures :posts, :topics, :users
  
  before do
    login_as(:moderator)
    @topic = mock_model(Topic)
    @topics = [@topic]
    @post = mock_model(Post)
    @posts = [@post]
    @forum = mock_model(Forum)
    @user = mock_model(User)
    Topic.should_receive(:find).and_return(@topic)
  end
  
  it "should be able to begin to split a post" do
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:find).and_return(@post)
    @posts.should_receive(:previous).and_return(@post)
    @posts.should_receive(:next).and_return(@post) 
    get 'split', :id => 1
  end
  
  it "should be able to split a post before" do
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:find).and_return(@post)
    @posts.should_receive(:all_previous).and_return(@posts + [@post])
    @topic.should_receive(:subject).and_return("Subject")
    @topic.should_receive(:forum).twice.and_return(@forum)
    @forum.should_receive(:topics).and_return(@topics)
    @post.should_receive(:user).and_return(@user)
    @topics.should_receive(:create).and_return(@topic)
    @topic.should_receive(:posts=).and_return(@posts)
    post 'split', { :id => 1, :direction => "before", :how => "just_split" }
  end
  
  it "should be able to split a post before and including that post" do
    split_mocking
    @posts.should_receive(:all_previous).and_return(@posts + [@post])
    post 'split', { :id => 1, :direction => "before_including", :how => "just_split" }
  end
  
  it "should be able to split a post after and including" do
    split_mocking
    @posts.should_receive(:all_next).and_return(@posts + [@post])
    post 'split', { :id => 1, :direction => "after_including", :how => "just_split" }
  end
  
  it "should be able to split a post after" do
    split_mocking
    @posts.should_receive(:all_next).and_return(@posts + [@post])
    post 'split', { :id => 1, :direction => "after", :how => "just_split" }
  end
  
  def split_mocking
    @topic.should_receive(:subject).and_return("Subject")
    @topic.should_receive(:forum).twice.and_return(@forum)
    @forum.should_receive(:topics).and_return(@topics)
    @post.should_receive(:user).and_return(@user)
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:find).and_return(@post)
    @topics.should_receive(:create).and_return(@topic)
    @topic.should_receive(:posts=).and_return(@posts)
  end
end