require File.dirname(__FILE__) + '/../spec_helper'
describe Topic, "in general" do
  fixtures :topics, :forums, :users
  before do
    @topic = mock("topic")
    @forum = mock("forum")
    @invalid_topic = topics(:invalid)
    @valid_topic = topics(:user_3)
    @another_valid_topic = topics(:user_2)
    @everybody = forums(:everybody)
    @sub_of_everybody = forums(:sub_of_everybody)
    @admins_only = forums(:admins_only)
    @administrator = users(:administrator)
    # Remove the call to reverse for an interesting failing test
    @posts = @valid_topic.posts.reverse
  end
  
  it "should validate everything" do
    #length of subject
    @invalid_topic.subject = "Srt"
    @invalid_topic.save.should be_false
    @invalid_topic.errors_on(:subject).should_not be_empty
    
    #presence of subject
    @invalid_topic.subject = nil
    @invalid_topic.save.should be_false
    @invalid_topic.errors_on(:subject).should_not be_empty
    
    #presence of forum_id
    @invalid_topic.save.should be_false
    @invalid_topic.errors_on(:forum_id).should_not be_empty
    
    #presence of user_id
    
    @invalid_topic.save.should be_false
    @invalid_topic.errors_on(:user_id).should_not be_empty
    
    # And now... for the obvious:
    
    @valid_topic.should be_valid
    
  end
  
  it "should be able to find the last 10 posts" do
    @valid_topic.last_10_posts.should eql(@posts)
  end
  
  it "should be able to show the string version" do
    @valid_topic.to_s.should eql("Fifth topic!")
  end
  
  it "should be able to lock a topic" do
    @valid_topic.should_not be_locked
    @valid_topic.lock!
    @valid_topic.should be_locked
  end
  
  it "should be able to unlock a topic" do
    @valid_topic.lock!
    @valid_topic.should be_locked
    @valid_topic.unlock!
    @valid_topic.should_not be_locked
  end
  
  it "should be able to sticky a topic" do
    @valid_topic.should_not be_sticky
    @valid_topic.sticky!
    @valid_topic.should be_sticky
  end
  
  it "should be able to unsticky a topic" do
    @valid_topic.sticky!
    @valid_topic.should be_sticky
    @valid_topic.unsticky!
    @valid_topic.should_not be_sticky
  end
  
  it "should be able to move a topic" do
    @valid_topic.move!(@sub_of_everybody.id)
    @valid_topic.forum_id.should eql(@sub_of_everybody.id)
  end
  
  it "should be able to merge two topics" do
    Topic.count.should eql(6)
    topic = @everybody.topics.create(:subject => "subject", :user => @administrator)
    post = topic.posts.create(:text => "First post", :user => @administrator)
    other_topic = @everybody.topics.create(:subject => "second subject", :user => @administrator)
    other_post = other_topic.posts.create(:text => "Second post", :user => @administrator)
    yet_another_post = topic.posts.create(:text => "Third post", :user => @administrator)
    topic.posts.size.should eql(2)
    other_topic.posts.size.should eql(1)
    Topic.count.should eql(8)
    topic.merge!([other_topic.id])
    topic.posts.size.should eql(3)
    Topic.count.should eql(7)
  end  
  
end
