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
  
  def update_last_post(new_forum, post=nil)
    post ||= posts.last
    self.last_post = post
    self.last_post_forum = nil
    self.save!
    for ancestor in (ancestors - [new_forum])
      if !post.nil?
        if ancestor.last_post.nil? || (ancestor.last_post.created_at < post.created_at)
          ancestor.last_post = post
          ancestor.last_post_forum = self
        end
      else
        ancestor.last_post = nil
        ancestor.last_post_forum = nil
      end
      ancestor.save
    end
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
