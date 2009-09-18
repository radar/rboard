class PHPBB::Config < ActiveRecord::Base
  establish_connection(:phpbb)
  set_table_name "phpbb_config"
  set_primary_key "config_name"
end