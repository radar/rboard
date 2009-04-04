class IpUser < ActiveRecord::Base
  belongs_to :ip
  belongs_to :user
end