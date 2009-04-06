class CanManageTopics < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_manage_topics, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_manage_topics
  end
end
