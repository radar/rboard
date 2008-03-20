require File.dirname(__FILE__) + '/../spec_helper'
describe Forum, "creation" do
  fixtures :forums
  before(:each) do
    @forum = forums(:invalid)
  end

  it "validation checks" do
    #title cannot be empty
    @forum.save.should be_false
    @forum.errors_on(:title).should_not be_empty
    
    #description cannot be empty
    @forum.save.should be_false
    @forum.errors_on(:description).should_not be_empty
  end
  
end

describe Forum, "in general" do
  fixtures :forums, :topics, :posts
  before do
    @forum = forums(:everybody)
    @empty_forum = forums(:sub_of_everybody)
  end
  it "should be able to find the last post" do
    @forum.last_post.should_not be_nil
  end
  it "should not be able to find the last post" do
    @empty_forum.last_post.should be_nil
  end
  it "should be able to find all descendants of a topic" do
    @forum.descendants.should eql([forums(:sub_of_everybody)])
  end
  
  it "should be able to find all the root forums" do
    @root_forums = Forum.find_all_without_parent
    @root_forums.size.should eql(4)
  end
  
  it "should be able to find the root of any forum, the highest ancestor" do
    @forum.root.should eql(@forum)
    @empty_forum.root.should eql(@forum)
  end
  
  
  it "should be able to show the string version of the forum" do
    @forum.to_s.should eql(@forum.title)
  end
  
  it "should be able to get all the topics in order" do
    @forum.topics.should eql(@forum.old_topics.sort_by { |t| t.posts.last.created_at }.reverse)
  end
  
  it "should be able to find the forum of the last post" do
    @forum.last_post_forum.should eql(nil)
  end
  
  it "should be able to find the ancestors for any given forum" do
    @empty_forum.ancestors.should eql([@forum])
  end
  
  it "should return true if the forum is a subforum of another" do
    @forum.sub?.should eql(false)
    @empty_forum.sub?.should eql(true)
  end
  
end
