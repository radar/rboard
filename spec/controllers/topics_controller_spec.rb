require File.dirname(__FILE__) + '/../spec_helper'
describe TopicsController do
  fixtures :users, :forums, :topics, :posts, :group_users, :groups, :permissions

  before do
    @admin_forum = forums(:admins_only)
    @admin_topic = topics(:admin)
    @everybody = forums(:everybody)
    @everybody_topic = topics(:user)
    @other_user_topic = topics(:other_user)
  end
  
  def params
    { :forum_id => @everybody.id, :id => @everybody_topic.id }
  end
  
  describe "as a plebian" do
    before do
      login_as(:plebian)
    end
    
    describe "in an unknown forum" do
      def params
        { :id => @everybody_topic.id }
      end

      it "should redirect to the proper forum" do
        get 'show', params
        response.should redirect_to(forum_topic_path(@everybody, @everybody_topic))
      end
    end
    
    describe "in the admin forum" do
      def denied
        response.should redirect_to(root_path)
        flash[:notice].should eql(t(:forum_permission_denied))
      end
      
      def admin_params
        { :forum_id => @admin_forum.id, :id => @admin_topic.id }
      end
      
      after do
        denied
      end
      
      it "should not be able to see the forum" do
        get 'index', admin_params
      end
      
      it "should not be able to see a topic" do
        get 'show', admin_params
      end
      
      it "should not be able to begin to create a topic" do
        get 'new', :forum_id => @admin_forum.id
      end
      
      it "should not be able to create a topic" do
        post 'create', { :forum_id => @admin_forum.id, :topic => { :subject => "Testing"}, :post => { :text => "1, two, free" } }
      end
    end
    
    describe "in the registered users forum" do
      
      it "should be able to see a topic in the free-for-all forum" do
        get 'show', params
        response.should render_template("show") 
      end
      
      it "should not be able to see a topic that doesn't exist" do
        get 'show', :id => 'missing'
        flash[:notice].should eql(t(:not_found, :thing => "topic"))
        response.should redirect_to(forums_path)
      end
    
      it "should be able to begin to create a new topic in the free-for-all forum" do
        get 'new', :forum_id => @everybody.id
        response.should render_template("new")
      end
    
      it "should be able to edit a topic that belongs to itself" do
        get 'edit', params
        response.should render_template("edit")
      end
    
      it "should be able to update a topic that belongs to itself" do
        put 'update', params.merge!(:topic => { :subject => "Testing" })
        flash.now[:notice].should eql(t(:topic_updated))
        response.should redirect_to(forum_topic_path(@everybody, @everybody_topic))
      end
    
      it "should not be able to update a topic that belongs to itself with invalid attributes for a topic" do
        put 'update', params.merge!(:topic => { :subject => ""})
        response.should render_template("edit")
      end
    
      it "should not be able to update a topic that belongs to itself with invalid attributes for a post" do
        put 'update', params.merge!(:topic => { :subject => "Testing"}, :post => { :text => ""})
        response.should render_template("edit")
      end
    
      it "should not be able to edit a topic that does not belong to itself" do
        get 'edit', { :forum_id => @everybody.id, :id => @other_user_topic.id }
        response.should redirect_to(forum_topic_path(@everybody, @other_user_topic))
        flash[:notice].should eql(t(:not_allowed_to_edit_topic))
      end
    
      it "should not be able to update a topic that does not belong to itself" do
        put 'update', { :topic => { :subject => "Text"},  :forum_id => @everybody.id, :id => @other_user_topic.id }
        response.should redirect_to(forum_topic_path(@everybody, @other_user_topic))
        flash[:notice].should eql(t(:not_allowed_to_edit_topic))
      end
    end
    
  end
  
  describe "as an admin" do
    before do
      login_as(:administrator)
    end
    
    it "should be able to see a topic in the admin forum" do
      get 'show', { :forum_id => @admin_forum.id, :id => @admin_topic.id }
      response.should render_template("show")
    end
    
    it "should be able to begin to create a topic" do
      get 'new', :forum_id => @admin_forum.id
      response.should render_template("new")
    end
    
    it "should be able to create a topic" do
      post 'create', { :forum_id => @admin_forum.id, :topic => { :subject => "Testing"}, :post => { :text => "1, two, free" } }
      flash[:notice].should eql(t(:created, :thing => "topic"))
    end
    
    it "should not be able to create a topic with invalid data" do
      post 'create', { :forum_id => @admin_forum.id, :topic => { :subject => ""}, :post => { :text => "1, two, free" } }
      response.should render_template("new")
      flash[:notice].should eql(t(:not_created, :thing => "topic"))
    end
    
    it "should be able to see a topic in the free-for-all forum" do
      get 'show', params
      response.should render_template("show")
    end
    
    it "should be able to edit a topic" do
      get 'edit', params
      response.should render_template("edit")
    end
  end

end