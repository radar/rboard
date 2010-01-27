require File.dirname(__FILE__) + '/spec_helper'

describe Array do
  it "should be able to find the previous elements in an array" do
    [1,2,3,4,5].all_previous(3).should eql([1,2])
  end

  it "should be able to find the previous elements in an array, including itself" do
    [1,2,3,4,5].all_previous(3, true).should eql([1,2,3])
  end

  it "should be able to find the previous element in the array" do
    [1,2,3,4,5].previous(3).should eql(2)
  end

  it "should be able to find no previous element for the first" do
    [1,2,3,4,5].previous(1).should eql(nil)
  end

  it "should be able to find the next element in the array" do
    [1,2,3,4,5].next(3).should eql(4)
  end

  it "should be able to find no next element for the first" do
    [1,2,3,4,5].next(5).should eql(nil)
  end

  it "should be able to find the susequent elements in an array" do
    [1,2,3,4,5].all_next(3).should eql([4,5])
  end

  it "should be able to find all the subsequent elements in an array" do
    [1,2,3,4,5].all_next(3, true).should eql([3,4,5])
  end


end