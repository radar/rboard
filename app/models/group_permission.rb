class GroupPermission < ActiveRecord::Base
  belongs_to :group
  belongs_to :permission
  belongs_to :forum
  belongs_to :category
end
