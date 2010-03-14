class Category < ActiveRecord::Base
  default_scope :order => "position"
  acts_as_tree
  acts_as_list

  has_many :forums, :dependent => :nullify
  has_many :permissions
  has_many :groups, :through => :permissions

  named_scope :without_parent, :conditions => { :parent_id => nil }, :include => :permissions

  validates_presence_of :name

end
