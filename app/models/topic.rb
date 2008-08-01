class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum
  has_many :posts, :dependent => :destroy, :order => "created_at asc"
  has_many :users, :through => :posts
  
  #makes error_messages_for return the wrong number of errors.
  validates_associated :posts, :message => nil
  validates_length_of :subject, :minimum => 4
  validates_presence_of :subject, :forum_id, :user_id
  attr_protected :sticky, :locked
  
  #silence the error messages
  def validates_associated_post_records;   end
  
  def last_10_posts
    posts.last(10).reverse
  end
end
