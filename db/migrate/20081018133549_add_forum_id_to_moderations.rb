class AddForumIdToModerations < ActiveRecord::Migration
  def self.up
    add_column :moderations, :forum_id, :integer
  end

  def self.down
    remove_column :moderations, :forum_id
  end
end
