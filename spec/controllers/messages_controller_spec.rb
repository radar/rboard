require File.dirname(__FILE__) + '/../spec_helper'

describe MessagesController do
  before do
    @user = mock("user")
    @users = [@users]
    @message = mock("message")
    @messages = [@message]
  end
  it "should not display to a non-logged in user" do
    get 'index'
    response.should redirect_to('login')
    flash[:notice] = "You must be logged in to do that!"
  end

  it "should be able to display the index action" do
    get 'index', {}, { :user => 1 }
  end
  
  it "should be able to create a new message" do
    Message.should_receive(:new).and_return(@message)
    User.should_receive(:find).with(:all, :order => "login ASC").and_return(@users)
    get 'new', {}, { :user => 2 }
  end
  
  it "a user cannot send a message to themselves" do
    User.should_receive(:find).with(:all, :order => "login ASC").and_return([])
    get 'new', {}, { :user => 2}
    response.should redirect_to(messages_path)
    flash[:notice].should_not be_blank
  end 
  
  it "should be able to create a new message" do
    
  end
end
