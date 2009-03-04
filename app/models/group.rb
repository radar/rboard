class Group < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  
  has_many :group_users
  has_many :users, :through => :group_users
  has_many :permissions
  
  validates_presence_of :name
  
  before_create :add_owner_to_users
  
  def add_owner_to_users
    users << owner
  end
end
