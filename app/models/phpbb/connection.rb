class PHPBB::Connection < ActiveRecord::Base
  establish_connection(:phpbb)
end