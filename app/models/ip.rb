class Ip < ActiveRecord::Base
  has_many :ip_users
  has_many :users, :through => :ip_users
  
  after_find do |record|
    record.update_attribute("updated_at", Time.now)
  end
end
