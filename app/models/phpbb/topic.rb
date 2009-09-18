class PHPBB::Topic < PHPBB::Connection
  set_table_name "phpbb_topics"
  set_primary_key "topic_id"
  belongs_to :forum, :class_name => "PHPBB::Forum"
  belongs_to :user, :class_name => "PHPBB::User", :foreign_key => "poster"
  has_many :posts, :class_name => "PHPBB::Post"
end