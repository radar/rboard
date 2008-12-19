require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::ThemesController do
  fixtures :users, :themes, :user_levels
  before do
    login_as(:administrator)
    @theme = mock_model(Theme)
    @themes = [@theme]
  end

  #Delete this example and add some real ones
  it "should be able show all themes" do
    Theme.should_receive(:find).with(:all, :order => "name ASC").and_return(@themes)
    get 'index'
  end

end
