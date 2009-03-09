class Category < ActiveRecord::Base
  acts_as_tree
  acts_as_list
  
  has_many :forums
  has_many :permissions
  has_many :groups, :through => :permissions
  
  named_scope :without_parent, :conditions => { :parent_id => nil }
  named_scope :viewable_to, lambda { |user| { :include => [:groups, :permissions], 
                           :conditions => ["groups.id IN (?) AND permissions.can_see_category = ? ", user.groups, true] } }

end
