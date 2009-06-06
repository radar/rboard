require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::GroupsController, "administrator" do
  fixtures :users, :group_users, :permissions, :groups
  before do
    login_as(:administrator)
    @id = groups(:administrators).id
  end
  
  it "should be able to see all the groups" do
    get 'index'
    response.should render_template("index")
  end
  
  it "should redirect to the users index" do
    get 'show', :id => @id
    response.should redirect_to(admin_group_users_path(@id))
  end
  
  it "should be able to begin to create a new group" do
    get 'new'
    response.should render_template("new")
  end
  
  it "should be able to create a new group" do
    post 'create', { :group => { :name => "Newbies"}, :permission => { :can_see_forum => true } }
    flash[:notice].should eql(t(:created, :thing => "group"))
    response.should redirect_to(admin_groups_path)
  end
  
  it "should not be able to create a group with invalid credentials" do
    post 'create', { :group => { :name => "" }, :permission => { :can_see_forum => true} }
    flash[:notice].should eql(t(:not_created, :thing => "group"))
    response.should render_template("new")
  end
  
  it "should be able to edit a group" do
    get 'edit', :id => @id
    response.should render_template("edit")
  end
  
  it "should be able to update a group" do
    put 'update', { :group => { :name => "Newbies" }, :permission => { :can_see_forum => true }, :id => @id }
    flash[:notice].should eql(t(:updated, :thing => "group"))
    response.should redirect_to(admin_groups_path)
  end
  
  it "should not be able to create a group with invalid credentials" do
    put 'update', { :group => { :name => "" }, :permission => { :can_see_forum => true }, :id => @id }
    flash[:notice].should eql(t(:not_updated, :thing => "group"))
    response.should render_template("edit")
  end
  
  it "should be able to destroy a group" do
    delete 'destroy', :id => @id
    flash[:notice].should eql(t(:deleted, :thing => "group"))
    response.should redirect_to(admin_groups_path)
  end
  
  it "should not be able to destroy a group that doesn't exist" do
    delete 'destroy', :id => 1234567890
    flash[:notice].should eql(t(:not_found, :thing => "group"))
    response.should redirect_to(admin_groups_path)
  end
  
  

end
