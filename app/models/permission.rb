class Permission < ActiveRecord::Base
  has_many :people_permissions
  has_many :groups, :through => :people_permissions, :as => "people"
  has_many :users, :through => :people_permissions, :as => "people"
end
