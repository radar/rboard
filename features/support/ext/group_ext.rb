class Group < ActiveRecord::Base
  # Ensures there's always a group with that name, and ideally only one.
  def self.ensure(name_or_attributes)
    # Wouldn't have to do the gsub if Rails correctly underscored strings like "Registered User"
    group = Group.find_by_name(name_or_attributes) if name_or_attributes.is_a?(String)
    
    group ||= Group.make(name_or_attributes.is_a?(String) ? name_or_attributes.gsub(" ", "").underscore.to_sym : name_or_attributes)
    group
  end
end
