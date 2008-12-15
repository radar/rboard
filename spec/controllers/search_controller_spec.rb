require File.dirname(__FILE__) + '/../spec_helper'
describe SearchController do
  fixtures :posts
  before do
    @posts = [mock_model(Post)]
  end
  
  it "should be able to find posts" do
    Post.should_receive(:search).and_return(@posts)
    post 'index', :query => "lolz"
  end
end
