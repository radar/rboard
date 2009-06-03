require 'features/support/blueprints'
Forum.delete_all
Group.delete_all
Permission.delete_all
User.delete_all

# The anonymous user
User.make_with_group(:anonymous, "Anonymous")

# Set up the permissions
# Also sets up admin user
Permission.make(:registered_users)
Permission.make(:anonymous)

# Create the user
User.make_with_group(:registered_user, "Registered Users")

Forum.make(:public_forum)
