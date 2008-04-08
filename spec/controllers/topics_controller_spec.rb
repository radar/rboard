require File.dirname(__FILE__) + '/../spec_helper'

describe TopicsController, "for not logged in user" do
  fixtures :users, :forums, :topics

  before do
    @admin_forum = forums(:admins_only)
    @admin_topic = topics(:admin)
    @topic = mock("topic")
    @topics = [@topic]
    @forum = mock_model(Forum)
    @forums = [@forum]
  end
  
  it "should check to see if a user is logged in before creating a new topic" do
    get 'new', { :forum_id => @admin_forum.id }
    response.should redirect_to('login')
    flash[:notice].should eql("You must be logged in to do that.")
  end

end  
  
describe TopicsController, "for logged in user" do
  fixtures :users, :forums, :topics

  before do
    @admin_forum = forums(:admins_only)
    @admin_topic = topics(:admin)
    @topic = mock("topic")
    @topics = [@topic]
    @forum = mock_model(Forum)
    @forums = [@forum]
  end
  
  it "should stop a user from being able to create a topic in a restricted forum" do
    Forum.should_receive(:find).twice.and_return(@forum)
    @forum.should_receive(:topics_created_by).and_return(3)
    get 'new', { :forum_id => @admin_forum.id }, { :user => 3 }
    response.should redirect_to(forums_path)
    flash[:notice].should eql("You do not have permissions to create topics in this forum.")
  end
  
  it "should be able to make a new topic" do
    Forum.should_receive(:find).twice.and_return(@forum)
    @forum.should_receive(:topics_created_by).and_return(3)
    get 'new', { :forum_id => @admin_forum.id }, { :user => 1}
    response.should render_template("new")
  end
  
  it "should not create a topic if a user is not allowed" do
    Forum.should_receive(:find).twice.and_return(@forum)
    @forum.should_receive(:topics_created_by).and_return(3)
    post 'create', { :topic => { :subject => "Test!" }, :post => { :text => "Testing!" }, :forum_id => @admin_forum.id }, { :user => 3}
    response.should redirect_to(forums_path)
    flash[:notice].should eql("You do not have permissions to create topics in this forum.")
  end
  
  it "should not show a restricted topic" do
    Forum.should_receive(:find).and_return(@forum)
    @forum.should_receive(:is_visible_to).and_return(3)
    get 'show', { :id => @admin_topic.id }
    response.should redirect_to(forums_path)
    flash[:notice].should eql("You do not have the permissions to access that topic.")
  end
end
  

