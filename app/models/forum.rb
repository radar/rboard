class Forum < ActiveRecord::Base
  default_scope :order => "title asc"

  acts_as_list :scope => :parent_id
  acts_as_tree :order => :position

  includes = [:children, :permissions, { :last_post => [:topic, :user] }, :last_post_forum]
  named_scope :without_category, :conditions => { :category_id => nil }, :include => includes, :order => "position"
  named_scope :without_parent, :conditions => { :parent_id => nil }, :include => includes, :order => "position" 
  named_scope :active, :conditions => { :active => true }


  has_many :moderations
  has_many :posts, :through => :topics, :source => :posts, :order => "posts.created_at desc"
  has_many :topics, :order => "topics.created_at desc", :dependent => :destroy 
  has_many :permissions
  has_many :groups, :through => :permissions

  belongs_to :category
  belongs_to :last_post, :class_name => "Post"
  belongs_to :last_post_forum, :class_name => "Forum"

  validates_presence_of :title, :description

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

  def sub?
    !parent_id.nil?
  end
end
