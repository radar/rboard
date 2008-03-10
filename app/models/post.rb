class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  belongs_to :editor, :class_name => "User", :foreign_key => "edited_by_id"
  validates_length_of :text, :minimum => 4
  validates_presence_of :text

  def forum
    topic.forum
  end
end
