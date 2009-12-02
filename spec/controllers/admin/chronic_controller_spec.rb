require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ChronicController do
  before do
    setup_user_base
    login_as(:administrator)
  end
  #Delete this example and add some real ones
  it "should be able to parse a valid time" do 
    post 'index', { :duration => "5 minutes from now"}
    response.should have_text((Time.now + 5.minutes).strftime("%d %B %Y %I:%M:%S%P"))
  end

  it "should not be able to parse and invalid time" do
    post 'index', { :duration => "Infinity" }
    response.should have_text(t(:invalid_format))
  end

end
