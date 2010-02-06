require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ForumsController do

  before do
    setup_user_base
    setup_forums
  end

  describe Admin::ForumsController, "not an admin" do

    it "should not let users without the correct permissions in" do
      get 'index'
      flash[:notice].should eql(t(:need_to_be_admin))
      response.should redirect_to(root_path)
    end
  end

  describe Admin::ForumsController, "admins" do

    before do
      login_as(:administrator)
    end

    it "should not be able to edit a forum that does not exist" do
      get 'edit', :id => 1234567890
      flash[:notice].should eql(t(:not_found, :thing => "forum"))
      response.should redirect_to(admin_forums_path)
    end
  end

end
