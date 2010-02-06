require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "installation" do
  it "installs everything" do
    silence_stream(STDOUT) do
      Rboard.install!("radar", "password", "radarlistener@gmail.com")
    end
    Forum.count.should eql(1)
    Topic.count.should eql(1)
    Group.count.should eql(3)
    Post.count.should eql(1)
    User.count.should eql(2)
    Theme.find_by_name("blue").is_default?.should be_true
  end

end