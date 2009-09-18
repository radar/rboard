require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "phpbb converter" do
  before do
    @models = [User, Category, Forum, Topic, Post]
  end
  
  it "should insert stuff" do
    @models.each do |model|
      model.count.should be_zero
    end

    PHPBB::Converter.convert
    
    @models.each do |model|
      model.count.should_not be_zero
    end
    
    
  end
end