require File.dirname(__FILE__) + '/../spec_helper'
describe Topic, "in general" do
  fixtures :topics, :forums, :users
  before do
    setup_user_base
    @invalid_topic = Topic.new.tap(&:save)
    @everybody = Forum.make(:public)

    # All this just to create a topic with a post...
    @valid_topic = valid_topic_for(@everybody)

    @another_valid_topic = valid_topic_for(@everybody)

    @sub_of_everybody = Forum.make(:sub_of_public)
    @administrator = User("administrator")
    # Remove the call to reverse for an interesting failing test
    @posts = @valid_topic.posts.reverse
    
    @ip = Ip.make(:localhost)
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
    @valid_topic.to_s.should eql("Default topic")
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

  it "should be able to move a topic and leave a redirect" do
    @valid_topic.move!(@sub_of_everybody.id, true)
    @valid_topic.forum_id.should eql(@sub_of_everybody.id)
    Topic.find_by_moved_to_id(@valid_topic.id).should_not be_nil
  end

  it "should be able to merge two topics" do
    Topic.count.should eql(2)
    topic = @everybody.topics.build(:subject => "subject", :user => @administrator, :ip => @ip)
    post = topic.posts.build(:text => "First post", :user => @administrator, :ip => @ip)
    topic.save
    other_topic = @everybody.topics.build(:subject => "second subject", :user => @administrator, :ip => @ip)
    other_post = other_topic.posts.build(:text => "Second post", :user => @administrator, :ip => @ip)
    yet_another_post = topic.posts.build(:text => "Third post", :user => @administrator, :ip => @ip)
    topic.save(false)
    other_topic.save(false)
    topic.posts.size.should eql(2)
    other_topic.posts.size.should eql(1)
    Topic.count.should eql(4)
    topic.merge!([other_topic.id], User("administrator"))
    topic.posts.size.should eql(3)
    Topic.count.should eql(3)
  end

  it "should belong to a user" do
    @valid_topic.belongs_to?(@administrator).should be_true
  end

end
