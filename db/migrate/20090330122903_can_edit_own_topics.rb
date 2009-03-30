class CanEditOwnTopics < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_edit_own_topics, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_edit_own_topics
  end
end
