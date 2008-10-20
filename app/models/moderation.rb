class Moderation < ActiveRecord::Base
  belongs_to :moderated_object, :polymorphic => true
  belongs_to :user
  belongs_to :forum
  named_scope :for_user, lambda { |user_id| { :conditions => ["user_id = ?", user_id] } }
  named_scope :topics, :conditions => "moderated_object_type = 'Topic'"
  named_scope :posts, :conditions => "moderated_object_type = 'Post'"
end
