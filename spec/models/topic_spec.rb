require File.dirname(__FILE__) + '/../spec_helper'
describe Topic, "creation" do
  fixtures :topics
  before do
    @invalid_topic = topics(:invalid)
    @valid_topic = topics(:user)
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

end
