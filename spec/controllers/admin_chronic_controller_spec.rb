require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::ChronicController do

  #Delete this example and add some real ones
  it "should be able to parse a valid time" do 
    post 'index', { :duration => "5 minutes from now"}, { :user => 1}
    response.should have_text((Time.now + 5.minutes).strftime("%d %B %Y %I:%M:%S%P"))
  end
  
  it "should not be able to parse and invalid time" do
    post 'index', { :duration => "Infinity" }, { :user => 1 }
    response.should have_text("Invalid format.")
  end

end
