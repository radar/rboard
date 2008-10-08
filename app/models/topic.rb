class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum
  has_many :posts, :dependent => :destroy, :order => "posts.created_at asc"
  has_many :users, :through => :posts
  belongs_to :last_post, :class_name => "Post"
  named_scope :recent, lambda { { :conditions => ["created_at > ?", 2.weeks.ago] } }
  
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
    was_old_last_post = old_forum.last_post == last_post
    new_forum = Forum.find(new_forum_id)
    update_attribute("forum_id", new_forum_id)
    is_new_last_post = new_forum.last_post.nil? || (new_forum.last_post.created_at <= posts.last.created_at)
    if is_new_last_post
      puts "UPDATING LAST POST FOR #{new_forum}"
      new_forum.update_last_post(new_forum, posts.last)
    end
    
    if was_old_last_post
      old_forum.reload
      puts "UPDATING LAST POST FOR #{old_forum}"
      old_forum.update_last_post(new_forum)
    end
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
