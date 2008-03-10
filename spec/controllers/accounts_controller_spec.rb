require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController, "the whole shebang" do
  fixtures :users, :banned_ips
  before do
    @user = mock_model(User)
    @users = [@user]
  end
  #Delete this example and add some real ones
  it "should not display a list of users to not logged in people" do
    User.should_not_receive("paginate")
    get 'index'
    response.should redirect_to('login')
  end
  
  it "should display a list of users to logged in people" do
    User.should_receive("paginate").with(:per_page=>30, :order=>"login ASC", :page=>nil).and_return(@users)
    get 'index', {}, { :user => 1 }
  end
  
  it "should redirect an already logged in user away from the login page" do
    get 'login', {}, { :user => 1 }
    response.should redirect_to(forums_path)
  end
  
  it "should be able to log in a user" do
    User.should_receive(:authenticate).and_return(@user)
    @user.should_receive(:update_attribute).at_least(3).times
    @user.stub!(:login_time)
    @user.should_receive(:remember_me).and_return(true)
    @user.stub!(:remember_token)
    @user.stub!(:remember_token_expires_at)
    post 'login', { :login => "Administrator", :password => "godly", :remember_me => 1 }
    response.should redirect_to(forums_path)
    flash[:notice].should eql("Logged in successfully")
  end
  
  it "shouldn't log in with an invalid password" do
    User.should_receive(:authenticate).and_return(nil)
    post 'login', { :login => "Administrator", :password => "dud_password" }
    response.should_not redirect_to(forums_path)
    flash[:notice].should eql("The username or password you provided is incorrect. Please try again.")
  end
  
  it "should remember a logged in person" do
    User.should_receive(:authenticate).and_return(@user)
    @user.should_receive(:update_attribute).at_least(3).times
    @user.stub!(:login_time)
    post 'login', { :login => "Administrator", :password => "godly"}
  end
  
  it "should be able to signup a user" do
    User.should_receive(:new).and_return(@user)
    @user.should_receive(:save!).and_return(true)
    post 'signup', { :login => "The One", :password => "hackingthematrix", :password_confirmation => "hackingthematrix" }
    flash[:notice].should eql("Thanks for signing up!")
  end
  
  it "should not be able to sign up a user that already exists" do
    User.should_receive(:new).and_return(@user)
    @user.should_receive(:save!).and_raise(ActiveRecord::RecordNotSaved)
    post 'signup', { :login => "administrator", :password => "hackingthematrix", :password_confirmation => "hackingthematrix" }
    flash[:notice].should eql("There was a problem during signup.")
    response.should render_template("signup")
  end
  
  it "should not be able to sign up a user when user is already logged in" do
    get 'signup', {}, { :user => 1 }
    flash[:notice].should eql("You are already logged in. You cannot signup again.")
    response.should redirect_to(forums_path)
  end
  
  it "a logged in user should be able to edit their profile" do
    get 'profile', { }, { :user => 1 }
    response.should render_template("profile")
  end
  
  it "should an un-logged in user should not be able to see the profile editing action" do
    get 'profile'
    response.should redirect_to('login')
  end
  
  it "should be able to update a user's profile" do
    get 'profile', { }, { :user => 1 }
    response.should render_template("profile")
  end
  
  it "should update a users profile" do
    User.should_receive(:find).twice.and_return(@user)
    post 'profile', { :user => { :password => "godly1", :password_confirmation => "godly", :signature => "Please respect the rules." }}, { :user => 1 }
    flash[:notice].should_not be_blank
  end
  
  it "should be able to get the user page of Administrator" do
    get 'user', { :id => "administrator" }
    response.should render_template("user")
  end
  
  
  it "should be able to logout a user" do
    get 'logout', { }, { :user => 3 }
    flash.should_not be_blank
    response.should redirect_to(forums_path)
  end
  
  it "should redirect a user if they're not logged in" do
    get 'logout'
  end
  
  it "should show a user that they're banned" do
    @request.remote_addr = "127.0.0.1"
    get 'index', { }, { :user => 4 }
    response.should redirect_to("accounts/ip_is_banned")
  end
  
  it "should not show that they are banned if they aren't" do
    get 'ip_is_banned', {}, { :user => 3 }
    response.should redirect_to(forums_path)
    flash[:notice].should_not be_blank
  end
  

end
