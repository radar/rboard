require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Configuration do
  before do
    Configuration.make(:subforums_display)
  end

  it "should be able to find a configuration with a valid key" do
    Configuration['subforums_display'].should_not be_nil
  end

  it "should not be able to find a configuration with an invalid key" do
    lambda { Configuration['invalid_key'] }.should raise_error(Configuration::NotFound, "The configuration option invalid_key does not exist.")
  end

end