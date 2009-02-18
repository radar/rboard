class Forum < ActiveRecord::Base
  acts_as_list :scope => :parent_id
  acts_as_tree :order => :position
  
  named_scope :without_category, :conditions => { :category_id => nil }, :order => "position"
  named_scope :viewable_to, lambda { |user| { :conditions => ["is_visible_to_id <= ?", user.user_level.position] } }
  named_scope :viewable_to_anonymous, lambda { { :conditions => { :is_visible_to_id => UserLevel.find_by_name("Anonymous").position } } }
  
  has_many :topics, :order => "topics.created_at DESC", :dependent => :destroy 
  has_many :posts, :through => :topics, :source => :posts, :order => "posts.created_at DESC"
  has_many :moderations
  
  belongs_to :category
  belongs_to :is_visible_to, :class_name => "UserLevel"
  belongs_to :topics_created_by, :class_name => "UserLevel"
  belongs_to :last_post, :class_name => "Post"
  belongs_to :last_post_forum, :class_name => "Forum"
  
  validates_presence_of :title, :description
  
  after_save :update_category_visibility
  after_destroy :update_category_visibility
    
  def to_s
    title
  end
  
  def update_last_post(new_forum, post=nil)
    post ||= posts.last
    self.last_post = post
    self.last_post_forum = nil
    save
    for ancestor in (ancestors - [new_forum])
      if !post.nil?
        if ancestor.last_post.nil? || (ancestor.last_post.created_at < post.created_at)
          ancestor.last_post = post
          ancestor.last_post_forum = self
        end
      else
        # does this ever get called? Test it and find out.
        ancestor.last_post = nil
        ancestor.last_post_forum = nil
      end
      ancestor.save
    end
  end
  
  def descendants
    children.map { |f| !f.children.empty? ? f.children + [f]: f }.flatten
  end
  
  def self.find_all_without_parent
    find_all_by_parent_id(nil)
  end
  
  def sub?
    !parent_id.nil?
  end
  
  # If the user is logged in, then user will not be :false
  # Check if a forum is visible to a user
  def viewable?(user=:false)
    (user != :false && is_visible_to_id <= user.user_level.position) || (user == :false && is_visible_to == UserLevel.find_by_name("Anonymous"))
  end
  
  # If the user is logged in, then user will not be :false
  # Check if a forum can have topics posted into it by a user
  def topics_creatable_by?(user=:false)
    (user != :false && topics_created_by_id <= user.user_level.position) || (user == :false && topics_created_by == UserLevel.find_by_name("Anonymous"))
  end
  
  private
  
    def update_category_visibility
      if category
        self.category.update_attribute("is_visible_to_id", UserLevel.find(category.forums.find(:all, :joins => :is_visible_to).map { |f| f.is_visible_to.position }.sort.last))
      end
    end
end
