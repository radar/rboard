class CanAddCategoryToPermissions < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_see_category, :boolean, :default => false
    add_column :permissions, :can_access_moderator_section, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_see_category
    remove_column :permissions, :can_access_moderator_section
  end
end
