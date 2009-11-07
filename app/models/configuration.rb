class Configuration < ActiveRecord::Base
  default_scope :order => :title

  def self.[](key)
    Configuration.find_by_key!(key).value
  rescue ActiveRecord::RecordNotFound
    raise NotFound, I18n.t(:Configuration_not_found, :key => key)
  end


  class NotFound < Exception; end
end
