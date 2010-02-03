class Edit < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :ip

  named_scope :visible, :conditions => { :hidden => false }
end
