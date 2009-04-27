require File.dirname(__FILE__) + '/../spec_helper'
describe SearchController do
  fixtures :posts
  before do
    @post = mock_model(Post)
    @posts = [@post]
  end
  
  it "should be able to find posts" do
    post 'index', :query => "lolz"
    response.should render_template("index")
  end
end
