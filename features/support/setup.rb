require 'features/support/blueprints'
require 'spec/macros/user_base'
Forum.delete_all
Group.delete_all
Permission.delete_all
User.delete_all

setup_user_base


Forum.make(:public_forum)
