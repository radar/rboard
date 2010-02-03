require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController, "as an admin" do
  before do
    setup_user_base
    setup_forums
    @user = mock_model(User)

    @users = [@user]
    @ranks = [mock_model(Rank)]
    @user_levels = [mock_model(UserLevel)]
    login_as(:administrator)
  end

  it "should be able to find all users" do
    User.expects(:paginate).returns(@users)
    get 'index'
  end

  describe Admin::UsersController, "working on a specific user" do
    before do
      User.expects(:find_by_permalink).returns(@user)
    end

    it "should be able to show a user" do
      get 'show', :id => 'administrator'
      response.should render_template('show')
    end

    it "should be able to edit a user" do
      Rank.expects(:custom).returns(@ranks)
      UserLevel.expects(:all).returns(@user_levels)
      get 'edit', :id => 'administrator'
      response.should render_template('edit')
    end

    it "should be able to update a user" do
      @user.expects(:update_attributes).returns(true)
      put 'update', { :id => 'administrator', :user => { :signature => "woot"}}
      flash[:notice].should eql(t(:updated, :thing => "user"))
      response.should redirect_to(admin_users_path)
    end

    it "should not be able to update a user with invalid attributes" do
      @user.expects(:update_attributes).returns(false)
      put 'update', { :id => 'administrator', :user => { :login => ''} }
      flash[:notice].should eql(t(:not_updated, :thing => "user"))
      response.should render_template("edit")
    end

    it "should be able to delete a user" do
      @user.should_receive(:destroy)
      delete 'destroy', :id => 'administrator'
      flash[:notice].should eql(t(:deleted, :thing => "user"))
      response.should redirect_to(admin_users_path)
    end

    # TODO: Work out how to get the data indexed in this test
    # if SEARCHING
    #   it "should be able to search for users" do
    #     post 'search', { :q => "ator" }
    #     response.body.should eql("administrator\nmoderator")
    #   end
    # end


  end
end