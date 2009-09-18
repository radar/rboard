class PHPBB::User < PHPBB::Connection
  set_table_name "phpbb_users"
  set_primary_key "user_id"
  has_many :topics, :class_name => "PHPBB::Topic"
  has_many :posts, :class_name => "PHPBB::Post"
end