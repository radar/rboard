class Post < ActiveRecord::Base
  # For distance_of_time_in_words
  include ActionView::Helpers::DateHelper
  belongs_to :user
  belongs_to :ip
  belongs_to :topic
  belongs_to :edited_by, :class_name => "User"
  
  has_many :edits, :order => "created_at DESC", :dependent => :destroy
  has_many :moderations, :as => :moderated_object, :dependent => :destroy
  
  validates_length_of :text, :minimum => 4
  validates_presence_of :text
  
  define_index do
      indexes text
      indexes user.login, :as => :user, :sortable => true
      has user_id, created_at, updated_at
      set_property :delta => true
  end
  
  delegate :subject, :to => :topic

  after_create :log_ip
  after_create :update_forum
  before_create :stop_spam
  after_destroy :find_latest_post
  
  attr_protected :forum_id, :user_id
  
  def stop_spam
    if !user.posts.last.nil? && user.posts.last.created_at > Time.now - TIME_BETWEEN_POSTS
      errors.add_to_base("You can only post once every #{distance_of_time_in_words(Time.now, Time.now - TIME_BETWEEN_POSTS)}") and return false
    end
  end

  def log_ip
    IpUser.create(:user => user, :ip => ip)
  end
  
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
    post.forum.increment(:posts_count)
    post.forum.save
  end
  
  def find_latest_post
    last = forum.posts.last
    if !last.nil?
      last = Post.update_latest_post(last)
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
