class AddCanStickyTopics < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_sticky_topics, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_sticky_topics
  end
end
