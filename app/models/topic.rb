class Topic < ActiveRecord::Base
  default_scope :order => "sticky desc"

  belongs_to :user
  belongs_to :ip  
  belongs_to :forum
  belongs_to :last_post, :class_name => "Post"
  belongs_to :moved_to, :class_name => "Topic"

  has_one :redirect, :class_name => "Topic", :foreign_key => "moved_to_id", :dependent => :destroy

  has_many :moderations, :as => :moderated_object, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :read_topics, :dependent => :destroy
  has_many :readers, :through => :read_topics, :source => :user
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :reporters, :through => :reports, :source => :user
  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions, :class_name => "User"
  has_many :users, :through => :posts

  named_scope :sorted, :order => "posts.created_at DESC, sticky DESC", :include => [:last_post, :readers]

  #makes error_messages_for return the wrong number of errors.
  validates_associated :posts, :message => nil
  validates_length_of :subject, :minimum => 4
  validates_presence_of :subject, :forum_id, :user_id

  attr_protected :sticky, :locked, :moved, :moved_to

  # Instead of using a counter_cache on the belongs_to we do this
  # because counter_cache doesn't take into account funky move! methods
  after_create :set_last_post
  after_create :log_ip
  after_create :increment_counters
  before_destroy :decrement_counters

  if SEARCHING
    define_index do
      indexes subject
    end if Topic.table_exists?
  end

  def log_ip
    IpUser.find_or_create_by_user_id_and_ip_id(user.id, ip.id)
  end


  #silence the error messages
  def validates_associated_post_records; end

  def decrement_counters
    forum.decrement!(:topics_count)
  end

  def set_last_post
    readers.clear
    update_attribute("last_post_id", posts.last.id) unless moved
    # TODO: May be intensive if a lot of people have all subscribed to the same topic.
    subscriptions.map { |s| s.increment!(:posts_count) }
  end

  def increment_counters
    forum.increment!(:topics_count)
    forum.increment!(:posts_count)
  end

  def to_s
    subject
  end

  def move!(new_forum_id, leave_redirect=false)
     # May actually have selected a shadow redirect topic.
    actual_topic = moved_to.nil? ? self : self.moved_to
    old_forum = Forum.find(actual_topic.forum_id)
    was_old_last_post = old_forum.last_post == last_post
    new_forum = Forum.find(new_forum_id)
    update_attribute("forum_id", new_forum_id)

    new_forum.increment!(:topics_count)
    new_forum.increment!(:posts_count, posts.count)
    old_forum.decrement!(:topics_count)
    old_forum.decrement!(:posts_count, posts.count)

    if leave_redirect
      redirect = old_forum.topics.build(:subject => subject, :created_at => created_at, :user => user, :ip => ip)
      redirect.moved = true
      redirect.moved_to = self
      redirect.save!
    else
      if self.redirect
        self.redirect.forum.decrement!(:posts_count, posts.count)
        self.redirect.destroy
      end
    end
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

  def merge!(moderation_ids, user, new_subject=nil)
    other_moderation_ids = moderation_ids - [id] - [id.to_s]
    self.subject = new_subject unless new_subject.blank?
    self.posts += Topic.find(other_moderation_ids, :include => :posts).map(&:posts).flatten!.sort_by(&:created_at)
    Topic.find(other_moderation_ids).map(&:destroy)
    self.last_post = posts.last
    moderations.for_user(user).delete_all
    save!
  end

  def last_10_posts
    posts.last(10).reverse
  end

  def belongs_to?(other_user)
    user == other_user
  end

end
