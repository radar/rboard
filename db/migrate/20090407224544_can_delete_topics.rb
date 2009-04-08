class CanDeleteTopics < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_delete_topics, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_delete_topics
  end
end
