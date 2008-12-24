class Category < ActiveRecord::Base
  acts_as_tree
  acts_as_list
  has_many :forums
  
  named_scope :without_parent, :conditions => { :parent_id => nil }
end
