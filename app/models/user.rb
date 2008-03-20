require 'digest/sha1'
class User < ActiveRecord::Base
  
  attr_accessor :password
  
  #validations
  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  
  #has
  has_many :posts
  has_many :topics
  has_many :inbox_messages, :class_name => "Message", :foreign_key => "to_id", :conditions => ["to_deleted = ?", false], :order => "id DESC"
  has_many :outbox_messages, :class_name => "Message", :foreign_key => "from_id", :conditions => ["from_deleted = ?", false], :order => "id DESC"
  has_many :unread_messages, :class_name => "Message", :foreign_key => "to_id", :conditions => ["to_read = ? AND to_deleted = ?", false, false]
  has_many :sent_messages, :class_name => "Message", :foreign_key => "from_id"
  has_many :banned_ips, :foreign_key => "banned_by"
  
  has_one :theme
  
  #belongs
  belongs_to :banned_by, :class_name => "User", :foreign_key => "banned_by"
  belongs_to :user_level
  belongs_to :style
  
  #before
  before_save :encrypt_password
  before_save :make_admin
  
  #after
  
  #misc. user information
  def rank
	rank = Rank.find(:first, :conditions => ["posts_required <= ? AND custom = 0",posts.size], :order => "posts_required DESC")
	rank.nil? ? "User" : rank.name
  end
  
  #permission checking 
  def make_admin
    self.user_level = UserLevel.find_by_name("Administrators") if User.count == 0
  end
  
  def admin?
    self.user_level.to_s == "Administrator"
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
  
  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  
  def authenticated?(password)
    crypted_password == encrypt(password)
  end
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end
  
  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end
  
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  protected
  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
  
  def password_required?
    crypted_password.blank? || !password.blank?
  end
end
