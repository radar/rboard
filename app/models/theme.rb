class Theme < ActiveRecord::Base
  default_scope :order => "name asc"
	has_many :users

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.default
    find_by_is_default(true)
  end

  def to_s
    File.readlines("#{THEMES_DIRECTORY.respond_to?("call") ? THEMES_DIRECTORY.call() : THEMES_DIRECTORY}/#{name}/style.css").to_s
  end


end