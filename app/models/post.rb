class Post < ActiveRecord::Base
  default_scope :order => "posts.created_at ASC"

  acts_as_list :column => "number", :scope => :topic_id

  # For distance_of_time_in_words
  include ActionView::Helpers::DateHelper
  belongs_to :user
  belongs_to :ip
  belongs_to :topic
  belongs_to :edited_by, :class_name => "User"

  has_many :edits, :order => "created_at DESC", :dependent => :destroy
  has_many :moderations, :as => :moderated_object, :dependent => :destroy
  has_many :attachments, :class_name => "PostAttachment"
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :reporters, :through => :reports, :source => :user

  validates_length_of :text, :minimum => 4
  validates_presence_of :text

  accepts_nested_attributes_for :attachments

  if SEARCHING
    define_index do
      indexes text
      set_property :delta => true
    end if Post.table_exists?
  end  
  delegate :subject, :to => :topic
  attr_protected :forum_id, :user_id

  after_create :log_ip
  after_create :update_forum
  before_create :stop_spam
  after_create :find_latest_post
  after_destroy :find_latest_post

  before_create :increment_counter
  before_destroy :decrement_counter

  def increment_counter
    forum.increment!(:posts_count)
  end

  def decrement_counter
    forum.decrement!(:posts_count)
  end

  def stop_spam
    if (!user.posts.last.nil? && user.posts.last.created_at > Time.now - TIME_BETWEEN_POSTS) && !user.can?(:ignore_flood_limit)
      errors.add_to_base("You can only post once every #{distance_of_time_in_words(Time.now, Time.now - TIME_BETWEEN_POSTS)}") and return false
    end
  end

  def log_ip
    IpUser.find_or_create_by_user_id_and_ip_id(user.id, ip.id)
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

  # Finds the latest post and updates the forum accordingly.
  # Called after create and destroy of posts.
  def find_latest_post
    # Posts for a forum are ordered in reverse.
    if last = forum.posts.first
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

  def page_for(user)
    (topic.posts.count.to_f / (user.per_page || PER_PAGE)).ceil
  end

end
