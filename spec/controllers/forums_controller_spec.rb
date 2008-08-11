require File.dirname(__FILE__) + '/../spec_helper'

describe ForumsController do
  fixtures :users, :forums, :user_levels

  before do
    @forum = mock(:forum)
    @forums = [@forum]
    @topic = mock(:topic)
    @topics = [@topic]
    @admin_forum = forums(:admins_only)
    @everybody_forum = forums(:everybody)
    @admin_level = user_levels(:administrator)
    @user_level = user_levels(:user)
  end

  it "should restrict which forums it shows when not logged in" do
    login_as(:plebian)
    Forum.should_receive(:find_all_without_parent).and_return(@forums)
    @forum.should_receive(:viewable?).and_return(true)
    @forum.stub!(:position)
    get 'index'
    response.should render_template("index")
  end
 
  it "should not show the admin forum to anonymous users" do
    Forum.should_receive(:find).and_return(@forum)
    @forum.should_receive(:viewable?).and_return(false)
    get 'show', { :id => @admin_forum.id }
    response.should redirect_to(forums_path)
    flash[:notice].should_not be_blank
  end
  
  it "should show the general forum to anonymous users" do
    Forum.should_receive(:find).twice.and_return(@forum)
    @forum.should_receive(:viewable?).and_return(true)
    @forum.should_receive(:children).and_return(@forums)
    @forum.should_receive(:topics).and_return(@topics)
    @topics.should_receive(:paginate).and_return(@topics)
    @forum.stub!(:position)
    get 'show', { :id => @everybody_forum.id }
    flash[:notice].should be_blank
    response.should render_template("show")
  end
  
  it "should show the admin forum to the administrator" do
    login_as(:administrator)
    Forum.should_receive(:find).twice.and_return(@forum)
    @forum.should_receive(:viewable?).and_return(true)
    @forum.should_receive(:topics).and_return(@topics)
    @topics.should_receive(:paginate).and_return(@topics)
    @forum.should_receive(:children).and_return(@forums)
    @forum.stub!(:position)
    get 'show', { :id => @admin_forum.id }
    response.should render_template("show")
  end
end
