require File.dirname(__FILE__) + '/../spec_helper'

describe ForumsController do
  fixtures :users, :forums, :user_levels

  before do
    @forum = mock(:forum)
    @forums = [@forum]
  end

  it "should restrict which forums it shows when not logged in" do
    Forum.should_receive(:find_all_without_parent).and_return(@forums)
    @forum.should_receive(:is_visible_to).and_return(3)
    get 'index', { }, { :user => users(:plebian).id }
    response.should render_template("index")
  end
  #    #This test fails when it should pass!
  #  it "should now show the moderator forum" do
  #    Forum.should_receive(:find_all_without_parent).and_return(@forums)
  #    @forum.should_receive(:is_visible_to).and_return(2)
  #    @forums.size.should eql(2)
  #    get 'index', { }, { :user => users(:moderator).id }
  #    response.should render_template("index")
  #  end
  #  #This test fails when it should pass!
  #  
  #  it "should now show the administrator forum" do
  #    Forum.should_receive(:find_all_without_parent).and_return(@forums)
  #    @forum.should_receive(:is_visible_to).and_return(3)
  #    @forums.size.should eql(3)
  #    get 'index', { }, { :user => users(:administrator).id }
  #    response.should render_template("index")
  #  end
 
  it "should not show the admin forum to anonymous users" do
    Forum.should_receive(:find).and_return(@forum)
    @forum.should_receive(:is_visible_to).and_return(3)
    get 'show', { :id => 1 }
    response.should redirect_to(forums_path)
    flash[:notice].should_not be_blank
  end
  
  it "should show the general forum to anonymous users" do
    Forum.should_receive(:find).and_return(@forum)
    @forum.should_receive(:is_visible_to).and_return(1)
    @forum.should_receive(:children).and_return(@forums)
    @forum.stub!(:position)
    get 'show', { :id => 3 }
    response.should render_template("show")
  end
  
  it "should show the admin forum to the administrator" do
    Forum.should_receive(:find).and_return(@forum)
    @forum.should_receive(:is_visible_to).and_return(3)
    @forum.should_receive(:children).and_return(@forums)
    @forum.stub!(:position)
    get 'show', { :id => 1 }, { :user => 1 }
    response.should render_template("show")
  end
end
