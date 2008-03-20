require File.dirname(__FILE__) + '/../spec_helper'

describe MessagesController do
  fixtures :messages, :users
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
  
  it "should not be able to create a new message" do
    Message.should_receive(:new).and_return(@message)
    @message.should_receive(:save).and_return(false)
    post 'create', { :message => { }}, { :user => 1}
    response.should render_template("new")
    flash[:notice].should eql("This message could not be sent.")
  end
  
  it "should not be able to create a new message" do
    Message.should_receive(:new).and_return(@message)
    @message.should_receive(:save).and_return(true)
    post 'create', { :message => { :to_id => 2, :text => "Some text" }}, { :user => 1 }
    response.should redirect_to(messages_path)
    flash[:notice].should eql("The message has been sent.")
  end
  
  it "should not be able to delete a message that doesn't belong to that user" do
    Message.should_receive(:find).and_return(@message)
    @message.should_receive(:belongs_to_user).and_return(false)
    get 'destroy', { :id => 2 }, { :user => 3 }
    flash[:notice].should_not be_blank
    response.should redirect_to(messages_path)
  end
  it "should be able to delete a message for a user, but not the message" do
    Message.should_receive(:find).and_return(@message)
    @message.should_receive(:belongs_to_user).and_return(true)
    @message.should_receive(:update_attribute).with("to_deleted", true).and_return(true)
    @message.should_receive(:from_id).and_return(2)
    @message.should_receive(:from_deleted).and_return(false)
    @message.should_receive(:to_deleted).and_return(true)
    get 'destroy', { :id => 2 }, { :user => 1}
    flash[:notice].should_not be_blank
    response.should redirect_to(messages_path)
  end
  
  it "should fully delete a message if both parties say so" do
    Message.should_receive(:find).and_return(@message)
    @message.should_receive(:belongs_to_user).and_return(true)
    @message.should_receive(:update_attribute).with("from_deleted", true).and_return(true)
    @message.should_receive(:from_deleted).and_return(true)
    @message.should_receive(:to_deleted).and_return(true)
    @message.should_receive(:destroy).and_return(true)
    @message.should_receive(:from_id).and_return(2)
    get 'destroy', { :id => 4}, { :user => 2 }
    flash[:notice].should_not be_blank
  end
  
  it "should not show a message to a person who doesn't own it" do
    Message.should_receive(:find).and_return(@message)
    @message.should_receive(:belongs_to_user).with(3).and_return(false)
    get 'show', { :id => 1 }, { :user => 3 }
    response.should redirect_to(messages_path)
    flash[:notice].should eql("That message does not belong to you.")
  end
  
  it "should say the receipient of the message has read it once viewed" do
    @administrator = users(:administrator)
    @moderator = users(:moderator)
    Message.should_receive(:find).and_return(@message)
    @message.should_receive(:belongs_to_user).with(1).and_return(true)
    @message.should_receive(:to).and_return(@administrator)
    @message.should_receive(:from).and_return(@moderator)
    @message.should_receive(:update_attribute).with("to_read", true).and_return(true)
    get 'show', { :id => 2 }, { :user => 1 }
  end
  
  it "should say the sender of the message has read it once viewed" do
    @administrator = users(:administrator)
    @moderator = users(:moderator)
    Message.should_receive(:find).and_return(@message)
    @message.should_receive(:belongs_to_user).with(2).and_return(true)
    @message.should_receive(:to).and_return(@administrator)
    @message.should_receive(:from).and_return(@moderator)
    get 'show', { :id => 2 }, { :user => 2 }
  end
  
  it "should let a user reply to a message" do
    Message.should_receive(:find).with("1").and_return(@message)
    User.should_receive(:find).with(:all, :order => "login ASC").and_return(@users)
    get 'reply', { :id => 1 }, { :user => 2 }
  end
  
  it "should show their outbox" do
    get 'sent', { }, { :user => 2 }
    
  end
  
  
  
end
