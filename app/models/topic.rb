class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum
  has_many :posts, :dependent => :destroy, :order => "created_at asc"
  has_many :users, :through => :posts
  
  #makes error_messages_for return the wrong number of errors.
  validates_associated :posts, :message => nil
  validates_length_of :subject, :minimum => 4
  validates_presence_of :subject, :forum_id, :user_id
  attr_protected :sticky, :locked
  
  #silence the error messages
  def validates_associated_post_records;   end
  
  def to_s
    subject
  end
  
  def move!(new_forum_id)
    old_forum = Forum.find(forum_id)
    new_forum = Forum.find(new_forum_id)
    update_attribute("forum_id", new_forum_id)
    posts.last.update_forum if posts.last != new_forum.posts.last
    old_forum.reload
    old_forum.update_last_post
  end
  
  def lock!
    update_attribute("locked", true)
  end
  
  def unlock!
    update_attribute("locked", false)
  end
  
  def sticky!
    update_attribute("sticky", true)
  end
  
  def unsticky!
    update_attribute("sticky", false)
  end
  
  def last_10_posts
    posts.last(10).reverse
  end
end
