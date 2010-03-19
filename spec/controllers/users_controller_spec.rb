require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do

  describe "as plebian" do
    before do
      setup_user_base
      setup_forums
      login_as(:registered_user)
    end

    it "should be able to see a list of users" do
      User.expects(:paginate)
      get 'index'
      response.should render_template("index")
    end

    it "should show a user" do
      get 'show', :id => "registered_user"
      flash[:notice].should be_nil
      response.should render_template("show")
    end

    it "should not show a user that doesn't exist" do
      get 'show', :id => "radarlistener"
      response.should redirect_to(users_path)
    end

    it "should be able to edit their own profile" do
      get 'edit', :id => "plebian"
      response.should render_template("edit")
    end

    it "should be able to update their password" do
      put 'update', { :id => "plebian", :user => { :password => "testing1234", :password_confirmation => "testing1234"} }
      flash[:notice].should eql(t(:password_has_been_changed))
    end 

    it "should be banned" do
      login_as(:banned_noob)
      get 'ip_is_banned'
      flash[:notice].should eql(t(:ip_is_banned))
    end
  end

end
