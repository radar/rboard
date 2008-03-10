class Forum < ActiveRecord::Base
  acts_as_list :scope => :parent_id
  acts_as_tree
  has_many :topics, :order => "created_at DESC", :dependent => :destroy
  has_many :posts, :through => :topics, :source => :posts
  validates_presence_of :title, :description
  belongs_to :visible_to, :class_name => "UserLevel", :foreign_key => "is_visible_to"
  belongs_to :creator_of_topics, :class_name => "UserLevel", :foreign_key => "topics_created_by"
  
  def last_post
    topics.empty? ? nil : topics.first.posts.last
  end
  
  def descendants
    children.map { |f| !f.children.empty? ? f.children + [f]: f }.flatten
  end
  
  def self.find_all_without_parent
    find_all_by_parent_id(nil)
  end
  

  
end
