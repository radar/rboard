class Forum < ActiveRecord::Base
  default_scope :order => "title asc"

  acts_as_list :scope => :parent_id
  acts_as_tree :order => :position

  includes = [:children, :permissions, { :last_post => [:topic, :user] }, :last_post_forum]
  scope :without_category, :conditions => { :category_id => nil }, :include => includes, :order => "position"
  scope :without_parent, :conditions => { :parent_id => nil }, :include => includes, :order => "position"
  scope :active, :conditions => { :active => true }


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

  def update_last_post
    unless frozen?
      post = latest_descendant_post || nil
      post_forum = post.try(:forum)
      self.last_post = post
      self.last_post_forum = (post_forum == self) ? nil : post_forum
      save!
    end
    ancestors.each { |ancestor| ancestor.update_last_post }
  end

  def descendants
    children.map { |f| !f.children.empty? ? f.descendants + [f] : f }.flatten
  end

  def sub?
    !parent_id.nil?
  end

private
  def latest_descendant_post
    forums = [self] + self.descendants
    forum_ids = forums.map(&:id)
    Post.find_by_sql("SELECT `posts`.* FROM `posts`
      INNER JOIN `topics` 
      ON `posts`.`topic_id` = `topics`.`id`
      WHERE `topics`.`forum_id` IN (#{forum_ids.join(', ')})
      ORDER BY `posts`.`created_at` DESC
      LIMIT 1").first
  end
end
