require File.dirname(__FILE__) + '/../spec_helper'
describe Topic, "creation" do
  fixtures :topics
  before do
    @topic = topics(:invalid)
  end
  it "should validate everything" do
    #length of subject
    @topic.subject = "Srt"
    @topic.save.should be_false
    @topic.errors_on(:subject).should_not be_empty
    
    #presence of subject
    @topic.subject = nil
    @topic.save.should be_false
    @topic.errors_on(:subject).should_not be_empty
    
    #presence of forum_id
    @topic.save.should be_false
    @topic.errors_on(:forum_id).should_not be_empty
    
    #presence of user_id
    
    @topic.save.should be_false
    @topic.errors_on(:user_id).should_not be_empty
  end
  

end
