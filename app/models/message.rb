class Message < ActiveRecord::Base
  belongs_to :to, :class_name => "User", :foreign_key => :to_id
  belongs_to :from, :class_name => "User", :foreign_key => :from_id

  # Used for the message view to provide a checkbox.
  attr_accessor :selected

  validates_presence_of :text

  def belongs_to?(user)
	   to == user || from == user
  end
end
