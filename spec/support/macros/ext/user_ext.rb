class User < ActiveRecord::Base
  # Ensures there's always a user with that login, and ideally only one.
  def self.ensure(login)
    # Wouldn't have to do the gsub if Rails correctly underscored strings like "Registered User"
    User(login.to_s) || User.make(login.to_s.gsub(" ", "").underscore.to_sym)
  end

  # Shame that I have to do this...
  def self.make_with_group(name, group)
    u = User.new(User.plan(name))
    u.groups << Group.ensure(group)
    u.save
    u
  end
end
