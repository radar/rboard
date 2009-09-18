require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "phpbb converter" do
  
  it "should insert stuff" do
    PHPBB::Converter.convert
  end
end