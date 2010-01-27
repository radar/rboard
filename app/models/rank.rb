class Rank < ActiveRecord::Base
  has_many :users, :dependent => :nullify

  named_scope :custom, :conditions => { :custom => true }

  def self.for_user(user)
    first(:conditions => ["posts_required >= ?", user.posts.count], :order => "posts_required DESC" )
  end

  validates_presence_of :name
end
