require File.dirname(__FILE__) + '/../spec_helper'
describe TopicsController do

  before do
    setup_user_base
    setup_forums
    @admin_forum = Forum("Admins Only")
    @admin_topic = @admin_forum.topics.first
    @everybody = Forum("Public Forum")
    @everybody_topic = @everybody.topics.first
    @other_user_topic = @everybody.topics.last
  end

  def params
    { :forum_id => @everybody.id, :id => @everybody_topic.id }
  end

  it "should go to the forum show action" do
    get 'index', :forum_id => @everybody.id
    response.should redirect_to(forum_path(@everybody))
  end

  describe "as a plebian" do
    before do
      login_as(:registered_user)
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

      it "should be able to create a topic with an attachment" do
        post 'create', { :forum_id => @everybody.id, :topic => { :subject => "This is a topic" }, :post => { :text => "And this is a post"}, :post_attachment => { "0" => { :file => File.open(::Rails.root.join("spec", "fixtures", "photo.jpg")) } } }
        flash[:notice].should eql(t(:created_with_attachments, :thing => "Topic", :count => 1))
      end

      it "should be able to create a topic" do
        post 'create', { :forum_id => @everybody.id, :topic => { :subject => "This is a topic" }, :post => { :text => "And this is a post"} }
        flash[:notice].should eql(t(:created, :thing => "Topic"))
      end

      it "should be able to edit a topic that belongs to itself" do
        @everybody_topic.user = User("registered_user")
        @everybody_topic.save!
        get 'edit', params
        response.should render_template("edit")
      end

      it "should be able to update a topic that belongs to itself" do
        @everybody_topic.user = User("registered_user")
        @everybody_topic.save!
        put 'update', params.merge!(:topic => { :subject => "Testing" })
        flash.now[:notice].should eql(t(:updated, :thing => "topic"))
        response.should redirect_to(forum_topic_path(@everybody, @everybody_topic))
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
end
