class Message < ActiveRecord::Base
  belongs_to :to, :class_name => "User", :foreign_key => :to_id
  belongs_to :from, :class_name => "User", :foreign_key => :from_id
  
  validates_presence_of :text
  
  def belongs_to?(user_id)
	   to_id == user_id || from_id == user_id
  end
end
