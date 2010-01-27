class Report < ActiveRecord::Base
  belongs_to :reportable, :polymorphic => true
  belongs_to :user

  validates_presence_of :text, :reportable_id, :reportable_type
end
