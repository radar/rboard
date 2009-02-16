class Category < ActiveRecord::Base
  acts_as_tree
  acts_as_list
  
  has_many :forums
  has_many :user_permissions
  has_many :group_permissions
  has_many :users, :through => :user_permissions
  has_many :groups, :through => :group_permissions
  
  named_scope :without_parent, :conditions => { :parent_id => nil }
  named_scope :visible_to, lambda { |user| { :include => [:users, :groups], :conditions => ["users.id = ? OR groups.id IN (?)", user.id, user.groups.map(&:id)] } } 

end
