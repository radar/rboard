require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubscriptionsController do
  fixtures :topics, :subscriptions, :users 
  
  before do
    @user = mock_model(User)
    @subscription = mock_model(Subscription)
    @subscriptions = [@subscription]
    @topic = mock_model(Topic)
    @forum = mock_model(Forum)
    login_as(:plebian)
  end
  
  it "should be able to see the topics I am subscribed to" do
    User.should_receive(:find).and_return(@user)
    @user.should_receive(:subscriptions).and_return(@subscriptions)
    @subscriptions.should_receive(:all).and_return(@subscriptions)
    @user.should_receive(:update_attribute).twice.and_return(Time.now)
    @user.should_receive(:time_zone).at_most(4).times.and_return("Australia/Adelaide")
    get 'index'
  end
  
  it "should be able to subscribe to a topic" do
    Topic.should_receive(:find).and_return(@topic)
    @topic.should_receive(:subscriptions).and_return(@subscriptions)
    @subscriptions.should_receive(:create).and_return(@subscription)
    @topic.should_receive(:forum).and_return(@forum)
    post 'create', :topic_id => 1
    flash[:notice].should eql(I18n.t(:topic_subscription))
  end
  
  it "should be able to unsubscribe from a topic" do
    User.should_receive(:find).and_return(@user)
    @user.should_receive(:subscriptions).and_return(@subscriptions)
    @user.stub!(:update_attribute)
    @user.stub!(:time_zone)
    @subscriptions.should_receive(:find).and_return(@subscription)
    @subscription.should_receive(:destroy).and_return(@subscription)
    @topic.should_receive(:forum).and_return(@forum)
    @subscription.should_receive(:topic).twice.and_return(@topic)
    delete 'destroy', :id => 1
    flash[:notice].should eql(I18n.t(:topic_unsubscription))    
  end
  
end