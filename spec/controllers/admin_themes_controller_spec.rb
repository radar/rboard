require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::ThemesController do
  fixtures :users, :themes
  before do
    login_as(:administrator)
    @theme = mock(:theme)
    @themes = [@theme]
  end

  #Delete this example and add some real ones
  it "should be able to update all themes" do
    @existing_themes = Dir.entries("#{RAILS_ROOT}/public/themes") - ['.svn','..','.']
    Theme.should_receive(:create).at_least(@existing_themes).times.and_return(@theme)
    @theme.should_receive(:name).and_return("Blue")
    Theme.should_receive(:find).with(:all).and_return(@themes)
    @theme.should_receive(:destroy).at_least(1).times.and_return(@theme)
    get 'index'
    
    
  end

end
