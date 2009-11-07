class Group < ActiveRecord::Base
  # Ensures there's always a group with that name, and ideally only one.
  def self.ensure(name)
    # Wouldn't have to do the gsub if Rails correctly underscored strings like "Registered User"
    group = Group.find_by_name(name)
    group ||= Group.make(name.gsub(" ", "").underscore.to_sym)
  end
end
