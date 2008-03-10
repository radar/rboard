class Theme < ActiveRecord::Base
	has_many :users
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def to_s
    File.readlines("#{RAILS_ROOT}/public/themes/#{name}/style.css").to_s
  end
  
end