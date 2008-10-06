require File.dirname(__FILE__) + '/../spec_helper'

describe EditsController, "as plebian" do
  fixtures :users, :posts, :topics, :edits
  
  before do
    login_as(:plebian)
  end

    
end
