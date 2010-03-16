require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do
  before do
    setup_user_base
    setup_forums
  end
  
  subject do
    Category.first
  end
  
  #Regression test for #25.
  it "should set the category_id to nil on all underling forums when destroyed" do
    forum = subject.forums.first
    forum.category_id.should_not be_nil
    subject.destroy
    forum.reload
    forum.category_id.should be_nil
  end
  
end