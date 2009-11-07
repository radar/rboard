class Edit < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  named_scope :visible, :conditions => { :hidden => false }
end
