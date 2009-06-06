require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ThemesController do
  fixtures :users, :themes, :groups, :group_users, :permissions
  
  before do
    login_as(:administrator)
    @theme = mock_model(Theme)
    @themes = [@theme]
  end

  it "should be able show all themes" do
    get 'index'
    response.should render_template("index")
  end
  
  it "should be able to make a theme the default" do
    put 'make_default', :id => themes(:green).id
    flash[:notice].should eql(t(:theme_is_now_default, :theme => "green"))
  end

end
