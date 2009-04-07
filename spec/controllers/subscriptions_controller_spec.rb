require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubscriptionsController do
  fixtures :topics, :subscriptions, :users, :groups, :group_users, :permissions
  
  before do
    login_as(:plebian)
    @user_topic = topics(:user)
  end
  
  it "should be able to see the topics I am subscribed to" do
    get 'index'
    response.should render_template("index")
  end
  
  it "should be able to subscribe to a topic" do
    post 'create', :topic_id => @user_topic.id
    flash[:notice].should eql(t(:topic_subscription))
  end
  
  it "should be able to unsubscribe from a topic" do
    sub = Subscription.create!(:topic => @user_topic, :user => users(:plebian))
    delete 'destroy', :id => sub.id
    flash[:notice].should eql(t(:topic_unsubscription))    
  end
  
end