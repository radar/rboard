require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ThemesController do

  before do
    setup_user_base
    login_as(:administrator)
    @blue = Theme.make(:name => "blue", :is_default => true)
    @green = Theme.make(:name => "green", :is_default => false)
  end

  it "should be able show all themes" do
    get 'index'
    response.should render_template("index")
  end

  it "should be able to make a theme the default" do
    put 'make_default', :id => @green.id
    flash[:notice].should eql(t(:theme_is_now_default, :theme => "green"))
  end

end
