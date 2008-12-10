class IpUser < ActiveRecord::Base
  belongs_to :ip
  belongs_to :user
  validates_uniqueness_of :ip, :scope => [:user]
end