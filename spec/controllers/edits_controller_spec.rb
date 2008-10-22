require File.dirname(__FILE__) + '/../spec_helper'

describe Moderator::EditsController, "as plebian" do
  fixtures :users, :posts, :topics, :edits
  
  before do
    login_as(:plebian)
  end

  it "should not be able to see a list of edits for a post" do
    get 'index'
    
    
end
