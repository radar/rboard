class Permission < ActiveRecord::Base
  belongs_to :group
  belongs_to :forum
  belongs_to :category
end
