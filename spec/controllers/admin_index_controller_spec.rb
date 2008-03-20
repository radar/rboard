require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::IndexController do
 fixtures :users, :posts
  #Delete this example and add some real ones
  it "should show the admin page" do
   login_as(:administrator)
   get 'index'
   response.should_not redirect_to("login")
  end
end
