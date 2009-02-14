class PeoplePermission < ActiveRecord::Base
  belongs_to :people, :polymorphic => true
  belongs_to :permission
  belongs_to :forum
end
