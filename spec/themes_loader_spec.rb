require File.dirname(__FILE__) + '/spec_helper'

describe ThemesLoader do
  it "should be able to load all the themes" do
    Theme.delete_all
    Theme.count.should eql(0)
    ThemesLoader.new
    Theme.count.should eql(Dir["#{RAILS_ROOT}/public/themes/*"].size)
  end

end
