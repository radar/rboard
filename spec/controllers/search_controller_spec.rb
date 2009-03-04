require File.dirname(__FILE__) + '/../spec_helper'
describe SearchController do
  fixtures :posts
  before do
    @post = mock_model(Post)
    @posts = [@post]
  end
  
  it "should be able to find posts" do
    Post.should_receive(:search).and_return(@posts)
    @post.should_receive(:forum).and_return(@forum)
    @forum.should_receive(:viewable?).and_return(true)
    post 'index', :query => "lolz"
  end
end
