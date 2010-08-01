require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../lib/themes_loader'

describe ThemesLoader do
  it "should be able to load all the themes" do
    Theme.delete_all
    Theme.count.should eql(0)
    ThemesLoader.new
    Theme.count.should eql(Dir["#{Rails.root}/public/themes/*"].size)
  end

end
