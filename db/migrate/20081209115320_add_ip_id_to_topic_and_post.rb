class AddIpIdToTopicAndPost < ActiveRecord::Migration
  def self.up
    add_column :topics, :ip_id, :integer
    add_index :topics, :ip_id
    add_column :posts, :ip_id, :integer
    add_index :posts, :ip_id
    add_column :edits, :ip_id, :integer
    add_index :edits, :ip_id
  end

  def self.down
    remove_column :topics, :ip_id
    remove_column :posts, :ip_id
    remove_column :edits, :ip_id
  end
end
