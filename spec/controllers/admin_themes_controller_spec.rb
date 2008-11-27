require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::ThemesController do
  fixtures :users, :themes, :user_levels
  before do
    login_as(:administrator)
    @theme = mock_model(Theme)
    @themes = [@theme]
  end

  #Delete this example and add some real ones
  it "should be able to update all themes" do
    @existing_themes = Dir.entries("#{RAILS_ROOT}/public/themes") - ['.svn','..','.']
    Theme.should_receive(:create).at_least(@existing_themes.size).times.and_return(@theme)
    @theme.should_receive(:name).and_return("Blue")
    Theme.should_receive(:find).with(:all).and_return(@themes)
    get 'index'
  end

end
