class BannedIp < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "banned_by"

  #kudos to http://www.regular-expressions.info/regexbuddy/ipaccurate.html for this awesome regex
  validates_format_of :ip, :with => /(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/
  validates_presence_of :banned_by, :ban_time, :ip
end
