require File.dirname(__FILE__) + '/../spec_helper'

describe MessagesController do
  before do
    setup_user_base
    setup_forums
    @moderator = User(:moderator)
    @plebian = User(:registered_user)
    @admin = User(:administrator)
    @message = Message.create(:to => @moderator, :from => @plebian, :text => "PLZ BAN THIS GUY")
    @disallowed_message = Message.create(:to => @admin, :from => @moderator, :text => "registered_user is annoying.")
  end

  describe MessagesController, "as a user" do
    before do
      login_as(:registered_user)
    end

    it "should be able to see their inbox" do
      get 'index'
      response.should render_template("index")
    end

    it "should be able to see a message" do
      get 'show', :id => @message.id
      response.should render_template("show")
    end

    it "should not be able to see a message between two other users" do
      get 'show', :id => @disallowed_message.id
      flash[:notice].should eql(t(:message_does_not_belong_to_you))
      response.should redirect_to(messages_path)
    end

    it "should be able to begin to write a message" do
      get 'new'
      response.should render_template("new")
    end

    it "should not be able to write a message if there is nobody else" do
      User.should_receive(:all).and_return([])
      get 'new'
      flash[:notice].should eql(t(:nobody_else))
      response.should redirect_to(messages_path)
    end

    it "should be able to send a message" do
      post 'create', :message => { :to_id => @moderator.id, :text => "MR MODERATOR SIR HE IS PICKING ON ME! WAAAAAAAAAAAAAAA" }
      flash[:notice].should eql(t(:message_sent))
      response.should redirect_to(messages_path)
    end

    it "should not be able to send a message without any text" do
      post 'create', :message => { :to_id => @moderator.id }
      flash[:notice].should eql(t(:message_not_sent))
      response.should render_template("new")
    end

    it "should be able to mark a message as deleted" do
      delete 'destroy', :id => @message.id
      flash[:notice].should eql(t(:deleted, :thing => "message"))
    end

    it "should not be able to delete a message that does not belong to them" do
      delete 'destroy', :id => @disallowed_message.id
      flash[:notice].should eql(t(:message_does_not_belong_to_you))
      response.should redirect_to(messages_path)
    end

    it "should be able to reply to a message" do
      get 'reply', :id => @message.id
      response.should render_template("reply")
    end

    it "should be able to see sent messages" do
      get 'sent'
      response.should render_template("sent")
    end

  end

  describe MessagesController, "as an admin" do
    before do
      login_as(:administrator)
    end

    it "should be able to see a message even though it doesn't belong to them" do
      get 'show', :id => @message.id
      response.should render_template("show")
    end

    it "should be able to delete a message that does not belong to them" do
      delete 'destroy', :id => @disallowed_message.id
      flash[:notice].should eql(t(:deleted, :thing => "message"))
      response.should redirect_to(messages_path)
    end

  end
end
