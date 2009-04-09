class Permission < ActiveRecord::Base
  belongs_to :group
  belongs_to :forum
  belongs_to :category
  
  named_scope :global, :conditions => { :forum_id => nil, :category_id => nil}

end
