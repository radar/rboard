require File.dirname(__FILE__) + '/../spec_helper'
describe Category, "in general" do
  fixtures :categories, :users
  before do
    @user = users(:plebian)
  end

  it "should be able to determine if it is visible by a user" do
    Category.viewable_to(@user).should eql([categories(:test)])
  end
  
end