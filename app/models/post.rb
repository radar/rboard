class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  has_many :edits, :order => "created_at DESC"
  has_many :visible_edits, :class_name => "Edit", :conditions => ["hidden != ?", false]
  validates_length_of :text, :minimum => 4
  validates_presence_of :text
  belongs_to :edited_by, :class_name => "User"
  
  define_index do
      indexes text
      indexes user.login, :as => :user, :sortable => true
      has user_id, created_at, updated_at
      set_property :delta => true
    end

  after_create :update_forum
  after_destroy :find_latest_post

  
  def update_forum
    forum.last_post = self
    Post.update_latest_post(self)
  end
  
  def self.update_latest_post(post)
    post.forum.last_post = post
    if post.forum.sub? 
      for ancestor in post.forum.ancestors
        ancestor.last_post = post
        ancestor.last_post_forum = post.forum
        ancestor.save
      end
    end
    post.forum.last_post = post
    post.forum.last_post_forum = nil
    post.forum.save
  end
  
  def find_latest_post
    last = forum.posts.last
    if !last.nil?
      Post.update_latest_post(last)
    else
      forum.last_post = nil
      forum.last_post_forum = nil
      forum.save
    end
  end
  
  def editor
    edits.last.user
  end
  
  def belongs_to?(other_user)
    user == other_user
  end
  
  def forum
    topic.forum
  end
end
