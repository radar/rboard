 require File.dirname(__FILE__) + '/../spec_helper'

describe Moderator::EditsController do
  fixtures :users, :posts, :topics, :edits
  
  before do
    @edit = mock(:edit)
    @edits = [@edit]
    @post = mock(:post)
    @posts = [@post]
  end
  
  describe Moderator::EditsController, "as plebian" do
    
    before do
      login_as("plebian")
    end
    
    it "should not be able to go to the index action" do
      get 'index'
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
    end
  end
  
  describe Moderator::EditsController, "as moderator" do
    before do
      login_as(:moderator)
    end
    
    it "should not be able to go to the index action if a post is not specified" do
      get 'index'
      response.should redirect_to(moderator_path)
      flash[:notice].should eql("The post or edit you were looking for cannot be found.")
    end
    
    it "should be able to go to the index action" do
      Post.should_receive(:find).and_return(@post)
      @post.should_receive(:edits).and_return(@edits)
      @edits.should_receive(:visible).and_return(@edits)
      get 'index', :post_id => 1
    end
    
    it "should be able to see a single edit" do
      Post.should_receive(:find).and_return(@post)
      @post.should_receive(:edits).and_return(@edits)
      @edits.should_receive(:visible).and_return(@edits)
      @edits.should_receive(:find).and_return(@edit)
      get 'show', :post_id => 1, :id => 1
    end
    
    it "should not be able to see an edit that does not exist" do
      Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get 'show', :post_id => 1, :id => 123456789
      response.should redirect_to(moderator_path)
      flash[:notice].should eql("The post or edit you were looking for cannot be found.")
    end
  end
  
  describe Moderator::EditsController, "as admin" do
    before do
      login_as(:administrator)
    end
    
    it "should be able to see an invisible edit" do
      Post.should_receive(:find).and_return(@post)
      @post.should_receive(:edits).and_return(@edits)
      @edits.should_receive(:find).and_return(@edit)
      get 'show', :id => 2, :post_id => 1
    end
    
    it "should error when trying to find an edit that does not exist" do
      Post.should_receive(:find).and_return(@post)
      @post.should_receive(:edits).and_return(@edits)
      @edits.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get 'show', :id => 123456789, :post_id => 1
      flash[:notice].should_not be_nil
      response.should redirect_to(moderator_path)
    end      
  end
end
