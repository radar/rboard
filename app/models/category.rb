class Category < ActiveRecord::Base
  acts_as_tree
  acts_as_list

  belongs_to :is_visible_to, :class_name => "UserLevel"
  has_many :forums
  named_scope :viewable_to, lambda { |user| { :conditions => (user == :false ? ["is_visible_to_id = ?", UserLevel.find(1)] : ["is_visible_to_id <= ?", user.user_level.position]) } }
  named_scope :without_parent, :conditions => { :parent_id => nil }

end
