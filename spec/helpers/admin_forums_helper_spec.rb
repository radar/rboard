require File.dirname(__FILE__) + '/../spec_helper'
describe Admin::ForumsHelper, "general" do
  include Admin::ForumsHelper

  before do
    setup_user_base
    setup_forums
    @everybody = Forum("Public Forum")
    @sub_of_everybody = @everybody.children.first
  end

  it "should correctly output forums" do
    select_display(@everybody).should eql("Public Forum")
    select_display(@sub_of_everybody).should eql("--Sub of Public Forum")
  end
end  
