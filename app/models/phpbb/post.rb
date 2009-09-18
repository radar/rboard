class PHPBB::Post < PHPBB::Connection
  set_table_name "phpbb_posts"
  set_primary_key "post_id"
  belongs_to :user, :class_name => "PHPBB::User", :foreign_key => "poster"
  belongs_to :topic, :class_name => "PHPBB::Topic"
end