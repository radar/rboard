class AddRedirectToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :moved, :boolean, :default => false
    add_column :topics, :moved_to_id, :integer
  end

  def self.down
    remove_column :topics, :moved
    remove_column :topics, :moved_to_id
  end
end
