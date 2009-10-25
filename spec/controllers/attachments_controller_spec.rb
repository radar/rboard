require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttachmentsController do
  fixtures :forums, :users
  it "should be able to attach a file" do
    login_as(:plebian)
    post 'create', { :forum_id => forums(:everybody).id, :attachment => { :file => File.read(File.dirname(__FILE__) + '/../fixtures/fugu.png') } }
    p flash.now
    p flash
    assigns[:attachment].new_record?.should be_false
  end
  
end