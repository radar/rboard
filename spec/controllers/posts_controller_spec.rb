require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController do
  fixtures :users
  before do
    login_as(:plebian)
    @post = mock("post")
    @posts = [@post]
    @user = mock("user")
  end
  it "should be able to edit a post" do
    Post.should_receive(:find).twice.and_return(@post)
    @post.should_receive(:user).and_return(@user)
    get 'edit', :id => 1
  end
  
  it "shouldn't be able to edit a post that doesn't belong to them" do
    Post.should_receive(:find).twice.and_return(@post)
    @post.should_receive(:user).and_return(@user)
    get 'edit', { :id => 2 }, { :user => 3}
    flash[:notice].should_not be_nil
    response.should redirect_to(forums_path)
  end
  
  it "should be able to update a post" do
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:update_attributes).and_return(true)
    put 'update', :id => 1
  end
  
end
