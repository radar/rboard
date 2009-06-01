require 'features/support/blueprints'
Forum.delete_all
Group.delete_all
Permission.delete_all
User.delete_all

# The anonymous user
User.make(:anonymous)

# Set up the permissions
# Also sets up admin user
Permission.make(:registered_users)
Permission.make(:anonymous)

# Create the user
User.make(:registered_user)

Forum.make(:public_forum)
