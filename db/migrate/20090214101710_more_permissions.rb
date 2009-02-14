class MorePermissions < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_reply_to_locked_topics, :boolean, :default => false
    add_column :permissions, :can_edit_topics, :boolean, :default => false
    add_column :permissions, :can_reply, :boolean, :default => false
    add_column :permissions, :can_edit_locked_topics, :boolean, :default => false
    add_column :permissions, :can_access_admin_section, :boolean, :default => false
    
  end

  def self.down
    remove_column :permissions, :can_reply_to_locked_topics
    remove_column :permissions, :can_edit_topics
    remove_column :permissions, :can_reply
    remove_column :permissions, :can_edit_locked_topics
    remove_column :permissions, :can_access_admin_section
  end
end
