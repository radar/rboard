class Theme < ActiveRecord::Base
	has_many :users
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def to_s
    File.readlines("#{THEMES_DIRECTORY}/#{name}/style.css").to_s
  end
  
end