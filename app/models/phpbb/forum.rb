class PHPBB::Forum < PHPBB::Connection
  set_primary_key "forum_id"
  set_table_name "phpbb_forums"
  has_many :topics, :class_name => "PHPBB::Topic"
end