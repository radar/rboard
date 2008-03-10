require File.dirname(__FILE__) + '/../spec_helper'
describe Post, "validations" do
  fixtures :posts
  before(:each) do
    @post = posts(:invalid)
  end
  
  it "should validate the length of text" do
    @post.text = "Shr"
    @post.save.should be_false
    @post.errors_on(:text).should_not be_empty
    @post.text = nil
    @post.save.should be_false
    @post.errors_on(:text).should_not be_empty
  end
  
end
describe Post, "general" do
  fixtures :posts, :topics, :forums
  
  before do
    @post = posts(:first)
  end
  it "should be able to find its forum" do
    @post.forum.should eql(forums(:everybody))
  end
end
