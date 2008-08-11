class Forum < ActiveRecord::Base
  acts_as_list :scope => :parent_id
  acts_as_tree
  has_many :topics, :order => "created_at DESC", :dependent => :destroy 
  has_many :posts, :through => :topics, :source => :posts, :order => "created_at DESC"
  validates_presence_of :title, :description
  belongs_to :is_visible_to, :class_name => "UserLevel"
  belongs_to :topics_created_by, :class_name => "UserLevel"
  belongs_to :last_post, :class_name => "Post"
  belongs_to :last_post_forum, :class_name => "Forum"
    
  def to_s
    title
  end
  
  #we do this because we want to order the topics by the last posts created_at date.
  #There's no easy way to do it
  alias_method :old_topics, :topics
  
  #NOT TESTED
  #POTENTIALLY UNSTABLE
  def update_last_post
    if old_forum.posts.first.nil?
      old_forum.last_post = nil
      old_forum.last_post_forum = nil
    else
      old_forum.last_post = old_forum.posts.first
      old_forum.last_post_forum = old_forum.posts.first.forum if old_forum.posts.first.forum != old_forum
    end
    old_forum.save
  end
  
  def topics
    old_topics.sort_by { |t| t.posts.last.created_at }.reverse
  end
  
  def descendants
    children.map { |f| !f.children.empty? ? f.children + [f]: f }.flatten
  end
  
  def self.find_all_without_parent
    find_all_by_parent_id(nil)
  end
  
  def root
    parent.nil? ? self : (parent.root == parent ? parent : parent.root)
  end
  
  def ancestors(list=[])
    if parent.nil?
      list << parent
    else
      list << parent
      parent.ancestors(list)
    end
    list.compact
  end
  
  def sub?
    !parent_id.nil?
  end
  
  def viewable?(logged_in=true, user=nil)
    (logged_in && is_visible_to.position <= user.user_level.position) || (!logged_in && is_visible_to.position == UserLevel.find_by_name("User").position)
  end
  
  def topics_creatable_by?(logged_in=true, user=nil)
    (logged_in && topics_created_by.position <= user.user_level.position) || (!logged_in && topics_created_by.position == UserLevel.find_by_name("User").position)
  end
end
