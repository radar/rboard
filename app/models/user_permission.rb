class UserPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :permission
  belongs_to :forum
  belongs_to :category
end
