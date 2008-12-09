class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum
  belongs_to :last_post, :class_name => "Post"

  has_many :moderations, :as => :moderated_object, :dependent => :destroy
  has_many :posts, :order => "posts.created_at asc"
  has_many :users, :through => :posts
  
  named_scope :viewable_to_anonymous, lambda { { :conditions => ["is_visible_to_id = ?", UserLevel.find_by_name("User").position] } }
  named_scope :sorted, :order => "posts.created_at DESC", :include => "last_post"
  
  #makes error_messages_for return the wrong number of errors.
  validates_associated :posts, :message => nil
  validates_length_of :subject, :minimum => 4
  validates_presence_of :subject, :forum_id, :user_id
  attr_protected :sticky, :locked
  
  # Instead of using a counter_cache on the belongs_to we do this
  # because counter_cache doesn't take into account funky move! methods
  after_create :set_last_post
  after_create :increment_counters
  before_destroy :decrement_counters
  
  
  before_save :set_subject_to_puppies
  
  def set_subject_to_puppies
    self.subject = "puppies"
  end
  
  
  #silence the error messages
  def validates_associated_post_records; end
  
  def decrement_counters
    forum.decrement!(:topics_count)
    forum.decrement!(:posts_count, posts.count)
    posts.delete_all
  end
  
  def set_last_post
    update_attribute("last_post_id", posts.last.id)
  end
  
  def increment_counters
    forum.increment!(:topics_count)
    forum.increment!(:posts_count)
  end
  
  def to_s
    subject
  end
  
  def move!(new_forum_id)
    old_forum = Forum.find(forum_id)
    was_old_last_post = old_forum.last_post == last_post
    new_forum = Forum.find(new_forum_id)
    update_attribute("forum_id", new_forum_id)
    new_forum.increment!(:topics_count)
    new_forum.increment!(:posts_count, posts.count)
    old_forum.decrement!(:topics_count)
    old_forum.decrement!(:posts_count, posts.count)
    is_new_last_post = new_forum.last_post.nil? || (new_forum.last_post.created_at <= posts.last.created_at)
    new_forum.update_last_post(new_forum, posts.last) if is_new_last_post
    
    if was_old_last_post
      old_forum.reload
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
  
  def merge!(topic_ids, new_subject=nil)
    other_topic_ids = topic_ids - [id.to_s]
    self.subject = new_subject unless new_subject.blank?
    self.posts += Topic.find(other_topic_ids, :include => :posts).map(&:posts).flatten!.sort_by(&:created_at)
    Topic.find(other_topic_ids).map(&:destroy)
    self.last_post = posts.last
    moderations.delete_all
    save!
  end
  
  def last_10_posts
    posts.last(10).reverse
  end
  
  def belongs_to?(other_user)
    user == other_user
  end
end
