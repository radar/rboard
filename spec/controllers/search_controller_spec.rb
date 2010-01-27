require File.dirname(__FILE__) + '/../spec_helper'
describe SearchController do
  fixtures :posts
  before do
    @post = mock_model(Post)
    @posts = [@post]
  end

  it "should be able to find posts" do
    post 'index', :query => "lolz"
    if SEARCHING
      response.should render_template("index")
    else
      response.should redirect_to root_path
      flash[:notice].should eql(t(:Search_disabled))
    end
  end
end
