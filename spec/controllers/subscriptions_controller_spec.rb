require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubscriptionsController do

  before do
    setup_user_base
    setup_forums
    login_as(:registered_user)
    @user_topic = Forum("Public Forum").topics.first
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
    sub = Subscription.create!(:topic => @user_topic, :user => User(:registered_user))
    delete 'destroy', :id => sub.id
    flash[:notice].should eql(t(:topic_unsubscription))
  end

end