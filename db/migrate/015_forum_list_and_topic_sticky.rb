class ForumListAndTopicSticky < ActiveRecord::Migration
  def self.up
    add_column :forums, :position, :integer
    add_column :topics, :sticky, :boolean, :default => false
  end

  def self.down
    remove_column :forums, :position
    remove_column :topics, :sticky
  end
end
